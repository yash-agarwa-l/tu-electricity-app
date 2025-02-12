import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart';

class SheetsService {
  final String spreadsheetId = "1fI1vhR1UD7Y1XQxqvIPYCjUcZwn2av66i6ai0cH84EE";
  final SheetsApi? sheetsApi;

  SheetsService(this.sheetsApi);

  /// Append Data to Sheet
  Future<void> appendData(String range, List<List<dynamic>> values) async {
    final ValueRange request = ValueRange.fromJson({
      "values": values,
    });

    await sheetsApi!.spreadsheets.values.append(
      request,
      spreadsheetId,
      range,
      valueInputOption: "RAW",
    );
    print("Data successfully added!");
  }

  /// Check if User is Authorized
  Future<bool> isAuthorizedUser(String email) async {
    final response = await sheetsApi!.spreadsheets.values.get(spreadsheetId, "Users!A:A");

    if (response.values != null) {
      List<String> emails = response.values!.map((row) => row[0].toString()).toList();
      return emails.contains(email);
    }
    return false;
  }

  /// Get a specific cell value
  Future<String?> getCellValue(String cell) async {
    final response = await sheetsApi!.spreadsheets.values.get(spreadsheetId, cell);

    if (response.values != null && response.values!.isNotEmpty) {
      return response.values![0][0].toString();
    }
    return null;
  }

  Future<List<dynamic>?> fetchFirstRow() async {
  try {
    final response = await sheetsApi!.spreadsheets.values.get(
      spreadsheetId,
      'Sheet1!E1:1',
    );

    return response.values?.first;
  } catch (e) {
    debugPrint("Error fetching first row: $e");
    return null;
  }
}

  /// Get multiple values from a range
  Future<List<List<dynamic>>> getRangeValues(String range) async {
    final response = await sheetsApi!.spreadsheets.values.get(spreadsheetId, range);
    return response.values ?? [];
  }

  /// Update a single cell
  Future<void> updateCell(String cell, dynamic value) async {
    final ValueRange request = ValueRange.fromJson({
      "values": [[value]],
    });

    await sheetsApi!.spreadsheets.values.update(
      request,
      spreadsheetId,
      cell,
      valueInputOption: "RAW",
    );
    print("Cell updated successfully!");
  }

  Future<List<String>> getAllSheets() async {
    final response = await sheetsApi!.spreadsheets.get(spreadsheetId);
    
    if (response.sheets != null && response.sheets!.isNotEmpty) {
      return response.sheets!.map((sheet) => sheet.properties!.title!).toList();
    }
    return [];
  }

//   Future<void> addOrUpdateEntry(
//      String fieldName, dynamic dataValue) async {
//   try {
//     final data = await fetchSheetData(spreadsheetId, sheetsApi);
//     if (data == null || data.isEmpty) return;

//     // Extract headers dynamically
//     List<dynamic> headers = data.first;
//     int fieldIndex = headers.indexOf(fieldName);

//     if (fieldIndex == -1) {
//       debugPrint("Field '$fieldName' not found in the sheet.");
//       return;
//     }

//     String date = DateTime.now().toIso8601String().split('T').first;
//     String hour = DateTime.now().hour.toString();
//     double temperature = 20 + Random().nextDouble() * 10; // Random temp between 20 and 30

//     List<dynamic>? existingRow;
//     int existingRowIndex = -1;

//     // Find existing row for current date & hour
//     for (int i = 1; i < data.length; i++) {
//       List<dynamic> row = data[i];
//       if (row.length > 2 && row[1] == date && row[2] == hour) {
//         existingRow = row;
//         existingRowIndex = i + 1; // Sheets is 1-based index
//         break;
//       }
//     }

//     if (existingRow != null) {
//       // Update only the required column
//       if (fieldIndex < existingRow.length) {
//         existingRow[fieldIndex] = dataValue;
//       } else {
//         while (existingRow.length <= fieldIndex) {
//           existingRow.add('');
//         }
//         existingRow[fieldIndex] = dataValue;
//       }

//       final request = sheets.ValueRange.fromJson({
//         'values': [existingRow]
//       });

//       await sheetsApi.spreadsheets.values.update(
//         request,
//         spreadsheetId,
//         'Sheet1!A$existingRowIndex:Z$existingRowIndex',
//         valueInputOption: 'RAW',
//       );
//     } else {
//       // Add new row
//       int sno = await getNextSno(spreadsheetId, sheetsApi);

//       List<dynamic> newRow = List.filled(headers.length, '');
//       newRow[0] = sno;
//       newRow[1] = date;
//       newRow[2] = hour;
//       newRow[3] = temperature;
//       newRow[fieldIndex] = dataValue;

//       final request = sheets.ValueRange.fromJson({
//         'values': [newRow]
//       });

//       await sheetsApi.spreadsheets.values.append(
//         request,
//         spreadsheetId,
//         'Sheet1',
//         valueInputOption: 'RAW',
//       );
//     }

//     debugPrint('Entry added or updated successfully.');
//   } catch (e) {
//     debugPrint("Error adding or updating entry: $e");
//   }
// }

}
