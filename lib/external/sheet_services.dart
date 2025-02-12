import 'dart:convert';
import 'package:http/http.dart' as http;

class SheetsService {
  final String spreadsheetId = "1fI1vhR1UD7Y1XQxqvIPYCjUcZwn2av66i6ai0cH84EE";

  Future<void> updateSheet(String accessToken, String range, List<List<dynamic>> values) async {
    final url = 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range:append'
        '?valueInputOption=RAW';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'values': values}),
    );

    if (response.statusCode == 200) {
      print("Data successfully added!");
    } else {
      print("Failed to update sheet: ${response.body}");
    }
  }
  Future<bool> isAuthorizedUser(String accessToken, String email) async {
    print("Checking email: $email");

    final response = await http.get(
      Uri.parse(
          'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/Users!A:A'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      List<dynamic> emails = (jsonDecode(response.body)['values'] as List)
          .map((row) => row[0].toString()) // Ensure it's properly mapped
          .toList();

      return emails.contains(email);
    }

    print("Error fetching data: ${response.body}");
    return false;
  }
Future<void> appendData(String accessToken, String range, List<List<dynamic>> values) async {
    final url = 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range:append?valueInputOption=RAW';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'values': values}),
    );

    if (response.statusCode == 200) {
      print("Data successfully added!");
    } else {
      print("Failed to append data: ${response.body}");
    }
  }

  /// Get a specific cell value
  Future<String?> getCellValue(String accessToken, String cell) async {
    final url = 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$cell';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.containsKey('values') && data['values'].isNotEmpty) {
        return data['values'][0][0]; // Return first value
      }
    } else {
      print("Failed to get cell value: ${response.body}");
    }
    return null;
  }

  /// Get multiple values from a range
  Future<List<List<dynamic>>> getRangeValues(String accessToken, String range) async {
    final url = 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<List<dynamic>>.from(data['values']);
    } else {
      print("Failed to get range values: ${response.body}");
    }
    return [];
  }

  /// Update a single cell with new data
  Future<void> updateCell(String accessToken, String cell, dynamic value) async {
    final url = 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$cell?valueInputOption=RAW';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'values': [[value]]}),
    );

    if (response.statusCode == 200) {
      print("Cell updated successfully!");
    } else {
      print("Failed to update cell: ${response.body}");
    }
  }



}
