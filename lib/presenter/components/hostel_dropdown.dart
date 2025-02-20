import 'package:flutter/material.dart';

class HostelDropdown extends StatelessWidget {
  final List<String> hostels;
  final String? selectedHostel;
  final ValueChanged<String?> onChanged;

  const HostelDropdown({
    super.key,
    required this.hostels,
    required this.selectedHostel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedHostel,
      decoration: InputDecoration(
        labelText: 'Select an Entry',
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      items: hostels.map((hostel) {
        return DropdownMenuItem<String>(
          value: hostel,
          child: Text(hostel),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an Entry';
        }
        return null;
      },
    );
  }
}
