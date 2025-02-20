import 'package:flutter/material.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';
import 'package:tu_electricity_app/presenter/components/gridview.dart';

class HomePageMain extends StatefulWidget {
  final SheetsService? sheetsService;

  const HomePageMain({super.key, required this.sheetsService});

  @override
  State<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  late Future<List<String>> _sheetsFuture;

  @override
  void initState() {
    super.initState();
    _sheetsFuture = fetchSheets();
  }

  Future<List<String>> fetchSheets() async {
    if (widget.sheetsService != null) {
      return await widget.sheetsService!.getAllSheets();
    } else {
      return [];
    }
  }

  Future<void> _refreshSheets() async {
    setState(() {
      _sheetsFuture = fetchSheets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sheets")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _refreshSheets,
          child: FutureBuilder<List<String>>(
            future: _sheetsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading sheets"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No sheets found"));
              } else {
                return SheetsGridView(sheets: snapshot.data!, sheetsService: widget.sheetsService);
              }
            },
          ),
        ),
      ),
    );
  }
}
