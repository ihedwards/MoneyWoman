import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Services for keyboard type
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'dart:convert';

class MyCustomForm extends StatefulWidget {
  final String title;
  final List<String> fields;
  final VoidCallback onFormClosed;
  final void Function(Map<String, String> expenseData) onFormSubmitted;

  // ignore: use_super_parameters
  const MyCustomForm({
    Key? key, // Fix typo in super constructor
    required this.title,
    required this.fields,
    required this.onFormClosed,
    required this.onFormSubmitted,
  }) : super(key: key); // Pass key to super constructor

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> controllers;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fields.length,
      (index) => TextEditingController(),
    );
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...widget.fields.map((field) {
            if (field.toLowerCase().contains('date')) {
              return buildDateField(field);
            } else if (field.toLowerCase().contains('amount')) {
              return buildAmountField(field);
            } else {
              return buildTextField(field);
            }
          }),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await storeData();
                _formKey.currentState!.reset();
                widget.onFormClosed();
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String field) {
    return TextFormField(
      controller: controllers[widget.fields.indexOf(field)],
      decoration: InputDecoration(labelText: field),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $field';
        }
        return null;
      },
    );
  }

  Widget buildDateField(String field) {
  final TextEditingController controller =
      controllers[widget.fields.indexOf(field)];

  return TextFormField(
    readOnly: true,
    controller: controller,
    decoration: InputDecoration(labelText: field),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter $field';
      }
      return null;
    },
    onTap: () async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now(),
      );
      if (pickedDate != null) {
        setState(() {
          final formattedDate = DateFormat.yMd().format(pickedDate); // Format pickedDate as a string
          controller.text = formattedDate; // Assign the formatted date string to the controller's text
        });
      }
    },
  );
}


  Widget buildAmountField(String field) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true), // Numeric keyboard with decimal point
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // Allow only digits and a single decimal point
      ],
      controller: controllers[widget.fields.indexOf(field)],
      decoration: InputDecoration(labelText: field),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $field';
        }
        return null;
      },
    );
  }

  Future<void> storeData() async {
    final Map<String, String> data = {};
    for (int i = 0; i < widget.fields.length; i++) {
      data[widget.fields[i]] = controllers[i].text;
    }
    await saveDataToSharedPreferences(data);
  }

  Future<void> saveDataToSharedPreferences(
    Map<String, String> data,
  ) async {
    try {
      String jsonData = jsonEncode(data);
      await prefs.setString(widget.title, jsonData);
      widget.onFormSubmitted(data);
    } catch (error) {
      // Handle error, if any
    }
  }
}
