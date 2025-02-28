import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:tu_electricity_app/external/authfunctions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tu_electricity_app/external/sheetauth.dart';

class SheetsService {
  final String authSpreadsheetId =
      "1fI1vhR1UD7Y1XQxqvIPYCjUcZwn2av66i6ai0cH84EE"; // Replace with your auth spreadsheet ID
  final String dataSpreadsheetId =
      "1NgqMRLMDj7ubEku9L9pqt1_tphnm0gAS24yxlhm4bMI"; // Replace with your data spreadsheet ID
  SheetsApi? _sheetsApi;

  SheetsService() {
    _initializeSheetsApi();
  }

  /// Ensures Sheets API is initialized
  Future<void> _initializeSheetsApi() async {
    await AuthFunctions().initializeSheetsApi();
    _sheetsApi = AuthFunctions().sheetsApi;
  }

  /// Fetch weather data
  Future<double> fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=30.3564&longitude=76.3646&current_weather=true'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['current_weather']['temperature'].toDouble();
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<List<dynamic>?> fetchFirstRow(String sheetId) async {
    try {
      final response = await _sheetsApi!.spreadsheets.values.get(
        dataSpreadsheetId,
        '$sheetId!1:1',
      );

      return response.values?.first.sublist(4);
    } catch (e) {
      debugPrint("Error fetching first row: $e");
      return null;
    }
  }

  /// Check if a user is authorized
  Future<bool> isAuthorizedUser(String email) async {
    await _initializeSheetsApi(); // Ensure API is ready
    final response = await _sheetsApi!.spreadsheets.values.get(dataSpreadsheetId, "Users!A:A");

    if (response.values != null) {
      List<String> emails = response.values!.map((row) => row[0].toString()).toList();
      return emails.contains(email);
    }
    return false;
  }

  /// Fetch a specific cell value
  Future<String?> getCellValue(String cell) async {
    await _initializeSheetsApi();
    final response = await _sheetsApi!.spreadsheets.values.get(dataSpreadsheetId, cell);

    if (response.values != null && response.values!.isNotEmpty) {
      return response.values![0][0].toString();
    }
    return null;
  }

  /// Fetch all sheet names
  Future<List<String>> getAllSheets() async {
    await _initializeSheetsApi();
    final response = await _sheetsApi!.spreadsheets.get(dataSpreadsheetId);

    if (response.sheets != null && response.sheets!.isNotEmpty) {
      return response.sheets!.map((sheet) => sheet.properties!.title!).toList();
    }
    return [];
  }

  /// Fetch full sheet data
  Future<List<List<dynamic>>?> fetchSheetData(String sheetId) async {
    await _initializeSheetsApi();
    final response = await _sheetsApi!.spreadsheets.values.get(dataSpreadsheetId, sheetId);
    return response.values ?? [];
  }

  /// Get the next serial number in a sheet
  Future<int> getNextSno(String sheetId) async {
    await _initializeSheetsApi();
    final response = await _sheetsApi!.spreadsheets.values.get(dataSpreadsheetId, '$sheetId!A:A');
    return (response.values?.length ?? 1);
  }

  /// Add or update an entry in the sheet
  Future<void> addOrUpdateEntry(String fieldName, dynamic dataValue, String sheetId) async {
    await _initializeSheetsApi();
    
    try {
      dataValue = double.parse(dataValue);
      final data = await fetchSheetData(sheetId);
      if (data == null || data.isEmpty) return;

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

      for (int i = 1; i < data.length; i++) {
        List<dynamic> row = data[i];
        if (row.length > 2 && row[1] == date) {
          existingRow = row;
          existingRowIndex = i + 1;
          break;
        }
      }

      if (existingRow != null) {
        if (fieldIndex < existingRow.length) {
          existingRow[fieldIndex] = dataValue;
        } else {
          while (existingRow.length <= fieldIndex) {
            existingRow.add('');
          }
          existingRow[fieldIndex] = dataValue;
        }

        final request = ValueRange.fromJson({'values': [existingRow]});
        await _sheetsApi!.spreadsheets.values.update(
          request,
          dataSpreadsheetId,
          '$sheetId!$existingRowIndex:$existingRowIndex',
          valueInputOption: 'USER_ENTERED',
        );
      } else {
        int sno = await getNextSno(sheetId);
        double temperature = await fetchWeather();

        List<dynamic> newRow = List.filled(headers.length, '');
        newRow[0] = sno;
        newRow[1] = date;
        newRow[2] = time;
        newRow[3] = temperature;
        newRow[fieldIndex] = dataValue;

        final request = ValueRange.fromJson({'values': [newRow]});
        await _sheetsApi!.spreadsheets.values.append(
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
