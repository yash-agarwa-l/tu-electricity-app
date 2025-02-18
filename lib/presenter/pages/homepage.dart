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
  List<String> hostels = [];
  Map<String, String> hostelData = {};
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? selectedHostel;

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

  Future<void> handleSubmit(String hostel, String consumption) async {
    if (widget.sheetsService == null) {
      print("SheetsService is not initialized!");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.sheetsService!.addOrUpdateEntry(
        hostel,
        consumption,
        widget.sheetId,
      );
      print("User data added successfully for $hostel!");
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Consumption Entry',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: hostels.length,
                    itemBuilder: (context, index) {
                      String hostel = hostels[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hostel,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              DecimalInputField(
                                labelText: 'Enter electricity consumption (in kW)',
                                onChanged: (text) {
                                  hostelData[hostel] = text;
                                },
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  if (hostelData[hostel] != null && hostelData[hostel]!.isNotEmpty) {
                                    await handleSubmit(hostel, hostelData[hostel]!);
                                  }
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
