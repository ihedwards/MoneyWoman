import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'dart:convert';

class MyCustomForm extends StatefulWidget {
  final String title;
  final List<String> fields;
  final VoidCallback onFormClosed;
  final void Function(Map<String, String> expenseData) onFormSubmitted; // Corrected function type definition

  const MyCustomForm({
    super.key,
    required this.title,
    required this.fields,
    required this.onFormClosed,
    required this.onFormSubmitted, required String tital, // Corrected parameter name and function type
  });

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> controllers;
  late SharedPreferences prefs; //SharedPreferences instance

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fields.length,
      (index) => TextEditingController(),
    );
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async  {
    prefs = await SharedPreferences.getInstance();
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
          ...widget.fields.map((field) => TextFormField(
            keyboardType: TextInputType.text,
            controller: controllers[widget.fields.indexOf(field)],
            decoration: InputDecoration(labelText: field),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $field';
              }
              return null;
            },
          )),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                storeData();
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

  void storeData() {
  final Map<String, String> data = {};
  for (int i = 0; i < widget.fields.length; i++) {
    data[widget.fields[i]] = controllers[i].text;
  }
  saveDataToSharedPreferences(data);
}

Future<void> saveDataToSharedPreferences(
    Map<String, String> data) async {
  try {
    String jsonData = jsonEncode(data); // Convert map to JSON string
    await prefs.setString(widget.title, jsonData); // Store JSON string in shared preferences
    print('Data stored in shared preferences: $data');
    widget.onFormSubmitted(data);
  } catch (error) {
    print('Error saving data to shared preferences: $error');
    // Handle error, if any
  }
}}