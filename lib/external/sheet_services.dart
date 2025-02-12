import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

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
}
