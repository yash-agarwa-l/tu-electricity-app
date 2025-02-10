import 'package:flutter/material.dart';
import 'package:tu_electricity_app/presenter/components/decimal_textformfield.dart';
import 'package:tu_electricity_app/presenter/components/hostel_dropdown.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? selectedHostel;

  final List<String> hostels = [
    'A',
    'B',
    'C',
    'D',
  ];
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    //TODO
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
    );
        
  }
}