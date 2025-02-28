import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SheetsService {
  final String authSpreadsheetId =
      "1fI1vhR1UD7Y1XQxqvIPYCjUcZwn2av66i6ai0cH84EE"; // Replace with your auth spreadsheet ID
  final String dataSpreadsheetId =
      "1NgqMRLMDj7ubEku9L9pqt1_tphnm0gAS24yxlhm4bMI"; // Replace with your data spreadsheet ID
  final SheetsApi? sheetsApi;

  SheetsService(this.sheetsApi);

  Future<double> fetchWeather() async {
    final response = await http.get(
        Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=30.3564&longitude=76.3646&current_weather=true'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['current_weather']['temperature'].toDouble();
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  /// Check if User is Authorized
  Future<bool> isAuthorizedUser(String email) async {
    final response = await sheetsApi!.spreadsheets.values.get(dataSpreadsheetId, "Users!A:A");

    if (response.values != null) {
      List<String> emails = response.values!.map((row) => row[0].toString()).toList();
      return emails.contains(email);
    }
    return false;
  }

  /// Get a specific cell value
  Future<String?> getCellValue(String cell) async {
    final response = await sheetsApi!.spreadsheets.values.get(dataSpreadsheetId, cell);

    if (response.values != null && response.values!.isNotEmpty) {
      return response.values![0][0].toString();
    }
    return null;
  }

  Future<List<dynamic>?> fetchFirstRow(String sheetId) async {
    try {
      final response = await sheetsApi!.spreadsheets.values.get(
        dataSpreadsheetId,
        '$sheetId!1:1',
      );

      return response.values?.first.sublist(4);
    } catch (e) {
      debugPrint("Error fetching first row: $e");
      return null;
    }
  }

  /// Get multiple values from a range
  Future<List<List<dynamic>>> getRangeValues(String range) async {
    final response = await sheetsApi!.spreadsheets.values.get(dataSpreadsheetId, range);
    return response.values ?? [];
  }

  Future<List<String>> getAllSheets() async {
    final response = await sheetsApi!.spreadsheets.get(dataSpreadsheetId);

    if (response.sheets != null && response.sheets!.isNotEmpty) {
      return response.sheets!.map((sheet) => sheet.properties!.title!).toList();
    }
    return [];
  }

  Future<List<List<dynamic>>?> fetchSheetData(String spreadsheetId, String sheetId) async {
    try {
      final response = await sheetsApi!.spreadsheets.values.get(
        spreadsheetId,
        sheetId, // Fetching all columns dynamically
      );

      return response.values ?? [];
    } catch (e) {
      debugPrint("Error fetching data from Google Sheets: $e");
      return null;
    }
  }

  Future<int> getNextSno(String spreadsheetId, String sheetId) async {
    try {
      final response = await sheetsApi!.spreadsheets.values.get(
        spreadsheetId,
        '$sheetId!A:A',
      );

      return (response.values?.length ?? 1);
    } catch (e) {
      debugPrint("Error fetching serial number: $e");
      return 1;
    }
  }

  Future<void> addOrUpdateEntry(String fieldName, dynamic dataValue, String sheetId) async {
    try {
      dataValue = double.parse(dataValue);
      final data = await fetchSheetData(dataSpreadsheetId, sheetId);
      if (data == null || data.isEmpty) return;

      // Extract headers dynamically
      List<dynamic> headers = data.first;
      int fieldIndex = headers.indexOf(fieldName);

      if (fieldIndex == -1) {
        debugPrint("Field '$fieldName' not found in the sheet.");
        return;
      }

      String date = DateTime.now().toIso8601String().split('T').first;
      String time = DateTime.now().toIso8601String().split('T').last.split('.')[0].substring(0, 5);

      List<dynamic>? existingRow;
      int existingRowIndex = -1;

      // Find existing row for current date & hour
      for (int i = 1; i < data.length; i++) {
        List<dynamic> row = data[i];
        if (row.length > 2 && row[1] == date) {
          existingRow = row;
          existingRowIndex = i + 1; // Sheets is 1-based index
          break;
        }
      }

      if (existingRow != null) {
        // Update only the required column
        if (fieldIndex < existingRow.length) {
          existingRow[fieldIndex] = dataValue;
        } else {
          while (existingRow.length <= fieldIndex) {
            existingRow.add('');
          }
          existingRow[fieldIndex] = dataValue;
        }

        final request = ValueRange.fromJson({
          'values': [existingRow]
        });

        await sheetsApi!.spreadsheets.values.update(
          request,
          dataSpreadsheetId,
          '$sheetId!$existingRowIndex:$existingRowIndex',
          valueInputOption: 'USER_ENTERED',
        );
      } else {
        // Add new row
        int sno = await getNextSno(dataSpreadsheetId, sheetId);
        double temperature = await fetchWeather();

        List<dynamic> newRow = List.filled(headers.length, '');
        newRow[0] = sno;
        newRow[1] = date;
        newRow[2] = time;
        newRow[3] = temperature;
        newRow[fieldIndex] = dataValue;

        final request = ValueRange.fromJson({
          'values': [newRow]
        });

        await sheetsApi!.spreadsheets.values.append(
          request,
          dataSpreadsheetId,
          sheetId,
          valueInputOption: 'USER_ENTERED',
        );
      }

      debugPrint('Entry added or updated successfully.');
    } catch (e) {
      debugPrint("Error adding or updating entry: $e");
    }
  }
}
