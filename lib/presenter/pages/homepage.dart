import 'dart:async';
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
  final _formKey = GlobalKey<FormState>();
  String? selectedHostel;
  List<String> hostels = [];
  String? electricityConsumption;
  bool _isLoading = true;
  bool _isSubmitting = false;
  Timer? _submissionTimer;

  @override
  void initState() {
    super.initState();
    fetchHostels();
  }

  @override
  void dispose() {
    _submissionTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchHostels() async {
  if (widget.sheetsService == null) {
    debugPrint("SheetsService is not initialized!");
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    return;
  }

  try {
    final List<dynamic>? headers = await widget.sheetsService!.fetchFirstRow(widget.sheetId);
    final List<List<dynamic>>? fullData = await widget.sheetsService!.fetchSheetData(widget.sheetId);
    String today = DateTime.now().toIso8601String().split('T').first;

    if (headers != null && headers.isNotEmpty) {
      List<dynamic>? todayRow;

      for (int i = 1; i < fullData!.length; i++) {
        final row = fullData[i];
        if (row.length > 1 && row[1] == today) {
          todayRow = row;
          break;
        }
      }

      List<String> availableHostels = [];

      for (int i = 0; i < headers.length; i++) {
        // Exclude first 4 fields like Sno, Date, Time, Temperature
        if (i < 4) continue;

        final columnValue = (todayRow != null && i < todayRow.length) ? todayRow[i] : "";
        if (columnValue == null || columnValue.toString().trim().isEmpty) {
          availableHostels.add(headers[i].toString());
        }
      }

      if (mounted) {
        setState(() {
          hostels = availableHostels;
          selectedHostel = hostels.isNotEmpty ? hostels.first : null;
        });
      }
    }
  } catch (e) {
    debugPrint("Error fetching hostels: $e");
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.sheetsService == null) {
      print("SheetsService is not initialized!");
      return;
    }

    if (mounted) {
      setState(() {
        _isSubmitting = true;
      });
    }

    _submissionTimer = Timer(Duration(seconds: 60), () {
      if (_isSubmitting && mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Submission timed out. Please try again.'),
          ),
        );
      }
    });

    try {
      await widget.sheetsService!.addOrUpdateEntry(
        selectedHostel!,
        electricityConsumption!,
        widget.sheetId,
      );
      print("User data added successfully!");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data submitted successfully!'),
          ),
        );
        setState(() {
          int currentIndex = hostels.indexOf(selectedHostel!);
          selectedHostel = hostels[(currentIndex + 1) % hostels.length];
        });
      }
    } catch (e) {
      print("Error appending data: $e");
    } finally {
      _submissionTimer?.cancel();
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void selectPreviousHostel() {
    if (mounted) {
      setState(() {
        int currentIndex = hostels.indexOf(selectedHostel!);
        selectedHostel = hostels[(currentIndex - 1 + hostels.length) % hostels.length];
      });
    }
  }

  void selectNextHostel() {
    if (mounted) {
      setState(() {
        int currentIndex = hostels.indexOf(selectedHostel!);
        selectedHostel = hostels[(currentIndex + 1) % hostels.length];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sheetId),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
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
                        if (mounted) {
                          setState(() {
                            selectedHostel = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    DecimalInputField(
                      labelText: 'Enter electricity consumption',
                      onChanged: (text) {
                        electricityConsumption = text;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.filled(onPressed: selectPreviousHostel, icon: Icon(Icons.arrow_back)),
                        SizedBox(
                          width: 200.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              await handleSubmit();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.onSecondary,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                              textStyle: const TextStyle(fontSize: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: const Text('Submit'),
                          ),
                        ),
                        IconButton.filled(onPressed: selectNextHostel, icon: Icon(Icons.arrow_forward)),
                      ],
                    ),
                  ],
                ),
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
