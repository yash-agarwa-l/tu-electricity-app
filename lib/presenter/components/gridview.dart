import 'package:flutter/material.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';
import 'package:tu_electricity_app/presenter/pages/homepage.dart';
import 'package:tu_electricity_app/presenter/pages/homepagereal.dart';
import 'package:tu_electricity_app/presenter/utils/colors.dart';

class SheetsGridView extends StatelessWidget {
  final List<String> sheets;
  final SheetsService? sheetsService;
  final List<Color> colors = [AppColors.color1, AppColors.color2, AppColors.color3, AppColors.color4, AppColors.color5];

  SheetsGridView({super.key, required this.sheets, required this.sheetsService});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 25.0,
        mainAxisSpacing: 25.0,
      ),
      itemCount: sheets.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(sheetsService: sheetsService, sheetId: sheets[index]),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colors[index % 5],
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
