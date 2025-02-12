import 'package:flutter/material.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';

class SheetsGridView extends StatelessWidget {
  final List<String> sheets;
  final SheetsService? sheetsService;

  SheetsGridView({required this.sheets, required this.sheetsService});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: sheets.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => HomePage(sheetName: sheets[index], sheetsService: sheetsService),
            //   ),
            // );
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                sheets[index],
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ),
        );
      },
    );
  }
}

