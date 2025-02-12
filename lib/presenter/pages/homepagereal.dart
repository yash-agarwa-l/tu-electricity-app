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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NextPage(sheetName: sheets[index], sheetsService: sheetsService),
              ),
            );
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

class HomePageMain extends StatefulWidget {
  final SheetsService? sheetsService;

  HomePageMain({super.key, required this.sheetsService});

  @override
  State<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  List<String> sheets = [];

  @override
  void initState() {
    super.initState();
    fetchSheets();
  }

  void fetchSheets() async {
    if (widget.sheetsService != null) {
      List<String> fetchedSheets = await widget.sheetsService!.getAllSheets();
      setState(() {
        sheets = fetchedSheets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sheets")),
      body: sheets.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SheetsGridView(sheets: sheets, sheetsService: widget.sheetsService),
    );
  }
}

class NextPage extends StatelessWidget {
  final String sheetName;
  final SheetsService? sheetsService;

  NextPage({required this.sheetName, required this.sheetsService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sheetName)),
      body: Center(
        child: Text("You selected $sheetName"),
      ),
    );
  }
}
