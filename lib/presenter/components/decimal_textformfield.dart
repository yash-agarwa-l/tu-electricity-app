import 'package:flutter/material.dart';

class DecimalInputField extends StatelessWidget {
  final String labelText;
  final ValueChanged<String> onChanged;

  const DecimalInputField({
    super.key,
    required this.labelText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }

        final regex = RegExp(r'^[0-9]+(\.[0-9]+)?$');
        if (!regex.hasMatch(value)) {
          return 'Please enter a valid decimal number';
        }
        final number = double.tryParse(value);
        if (number != null && number <= 0) {
          return 'Value must be greater than zero';
        }
        return null;
      },
    );
  }
}
