import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCustomForm extends StatefulWidget {
  final String title;
  final List<String> fields;
  final VoidCallback onFormClosed;
  final void Function(Map<String, String> expenseData) onFormSubmitted; // Corrected function type definition

  const MyCustomForm({
    Key? key,
    required this.title,
    required this.fields,
    required this.onFormClosed,
    required this.onFormSubmitted, // Corrected parameter name and function type
  }) : super(key: key);

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> controllers;
 
  List<Map<String, String>> tableData = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fields.length,
      (index) => TextEditingController(),
    );
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
            keyboardType: TextInputType.text, // You can adjust the keyboard type as per your requirement
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
          ElevatedButton(
            onPressed: widget.onFormClosed,
            child: const Text('Go back'),
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
    setState(() {
      tableData.add(data);
    });
    widget.onFormSubmitted(data); // Notify parent widget about form submission
  }
}
