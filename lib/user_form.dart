//issue @ line 155
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Services for keyboard type
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyCustomForm extends StatefulWidget { //all the important needed stuff for the form
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
  String formatCurrency(double amount) {
    // Example implementation for currency formatting
    return '\$${amount.toStringAsFixed(2)}'; // Formats as $00.00
  }
  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fields.length,
      (index) => TextEditingController(),
    );
    initSharedPreferences(); //initializing how the data is saved
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance(); //how shared preferences works
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { //putting everything in
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row( //alignment and style. asthetics
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
          ElevatedButton( //when button is pressed this stuff happens
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await storeData();
                _formKey.currentState!.reset();
                widget.onFormClosed();
              }
            },
            child: const Text('Submit'), //words in button
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String field) {
    return TextFormField(
      controller: controllers[widget.fields.indexOf(field)], //have to have these requirements before submitting form
      decoration: InputDecoration(labelText: field),
      validator: (value) {
        if (value == null || value.isEmpty) { //no nulls
          return 'Please enter $field'; //what is displayed when nulls appear
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
    decoration: InputDecoration(labelText: field), //same thing
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter $field';
      }
      return null;
    },
    onTap: () async {
      final DateTime? pickedDate = await showDatePicker( //allows the calendar to appear, pick the date you want
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
      // Custom TextInputFormatter to enforce currency format
      TextInputFormatter.withFunction((oldValue, newValue) {
        // Enforce currency format (e.g., $123,456.78)
        final formattedValue = formatCurrency(double.parse(newValue.text)); //ISSUE!!!
        return TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      }),
    ],
    controller: controllers[widget.fields.indexOf(field)], //same thing
    decoration: InputDecoration(labelText: field),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter $field';
      }
      if (!RegExp(r'^\$?\d{1,3}(,\d{3})*(\.\d{2})?$').hasMatch(value)) { //is currency in right format
        return 'Please enter a valid $field (e.g., \$123,456.78)';
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
    } catch (error) { // Handle error, if any
    }
  }
}
