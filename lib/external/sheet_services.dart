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
  final response = await http.get(
    Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/1Y29Po4-esNFBg9KpYjhDRFFzcI4ricZtfeE16qopnyk/values/Users!A:A'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200) {
    List<dynamic> emails = jsonDecode(response.body)['values'].expand((i) => i).toList();
    return emails.contains(email);
  }
  return false;
}

}
