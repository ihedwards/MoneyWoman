import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'dart:convert';

class MyCustomForm extends StatefulWidget {
  final String title;
  final List<String> fields;
  final VoidCallback onFormClosed;
  final void Function(Map<String, String> expenseData) onFormSubmitted;

  const MyCustomForm({
    Key? key,
    required this.title,
    required this.fields,
    required this.onFormClosed,
    required this.onFormSubmitted, required String tital,
  }) : super(key: key);

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
    initSharedPreferences(); // Initialize SharedPreferences
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    // Dispose of TextEditingController instances
    controllers.forEach((controller) => controller.dispose());
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await storeData(); // Await the async method call
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

  Future<void> storeData() async {
    final Map<String, String> data = {};
    for (int i = 0; i < widget.fields.length; i++) {
      data[widget.fields[i]] = controllers[i].text;
    }
    await saveDataToSharedPreferences(data); // Await the async method call
  }

  Future<void> saveDataToSharedPreferences(
    Map<String, String> data,
  ) async {
    try {
      String jsonData = jsonEncode(data);
      await prefs.setString(widget.title, jsonData);
      print('Data stored in shared preferences: $data');
      widget.onFormSubmitted(data);
    } catch (error) {
      print('Error saving data to shared preferences: $error');
      // Handle error, if any
    }
  }
}