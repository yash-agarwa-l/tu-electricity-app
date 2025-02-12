import 'package:flutter/material.dart';
import 'package:tu_electricity_app/domain/store.dart';
import 'package:tu_electricity_app/external/sheet_services.dart';
import 'package:tu_electricity_app/presenter/components/decimal_textformfield.dart';
import 'package:tu_electricity_app/presenter/components/hostel_dropdown.dart';

class Homepage extends StatefulWidget {
  final SheetsService? sheetsService; 

  const Homepage({super.key, required this.sheetsService});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? selectedHostel;
  final List<String> hostels = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              HostelDropdown(
                hostels: hostels,
                selectedHostel: selectedHostel,
                onChanged: (value) {
                  setState(() {
                    selectedHostel = value;
                  });
                },
              ),
              DecimalInputField(
                labelText: 'Enter electricity consumption (in kW)',
                onChanged: (text) {
                  print('Text changed: $text');
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (widget.sheetsService == null) {
                    print("SheetsService is not initialized!");
                    return;
                  }

                  final accessToken = await TokenFunctions.getToken();
                  String range = "Sheet1!A1";
                  List<List<dynamic>> values = [
                    ["Yash Agarwal", "Developer", "yash@example.com"], 
                  ];

                  try {
                    await widget.sheetsService!.appendData(range, values);
                    print("User data added successfully!");
                  } catch (e) {
                    print("Error appending data: $e");
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
