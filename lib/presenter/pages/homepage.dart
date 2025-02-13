import 'package:flutter/material.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';
import 'package:tu_electricity_app/presenter/components/decimal_textformfield.dart';
import 'package:tu_electricity_app/presenter/components/hostel_dropdown.dart';

class Homepage extends StatefulWidget {
  final SheetsService? sheetsService;
  final String sheetId;

  const Homepage({super.key, required this.sheetsService, required this.sheetId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? selectedHostel;
  List<String> hostels = [];
  String? electricityConsumption;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchHostels();
  }

  Future<void> fetchHostels() async {
    if (widget.sheetsService == null) {
      debugPrint("SheetsService is not initialized!");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final List<dynamic>? firstRow = await widget.sheetsService!.fetchFirstRow(
        widget.sheetId,
      );
      if (firstRow != null && firstRow.isNotEmpty) {
        setState(() {
          hostels = firstRow.map((e) => e.toString()).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching hostels: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> handleSubmit() async {
    if (widget.sheetsService == null) {
      print("SheetsService is not initialized!");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.sheetsService!.addOrUpdateEntry(
        selectedHostel!,
        electricityConsumption!,
        widget.sheetId,
      );
      print("User data added successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data submitted successfully!'),
        ),
      );
    } catch (e) {
      print("Error appending data: $e");
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Consumption Entry',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 20),
                  HostelDropdown(
                    hostels: hostels,
                    selectedHostel: selectedHostel,
                    onChanged: (value) {
                      setState(() {
                        selectedHostel = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DecimalInputField(
                    labelText: 'Enter electricity consumption (in kW)',
                    onChanged: (text) {
                      electricityConsumption = text;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        await handleSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading || _isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
