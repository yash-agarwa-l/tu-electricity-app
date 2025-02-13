import 'package:flutter/material.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';
import 'package:tu_electricity_app/presenter/components/gridview.dart';



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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: sheets.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SheetsGridView(sheets: sheets, sheetsService: widget.sheetsService),
      ),
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
