import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MyCustomForm extends StatefulWidget {
  final String title;
  final List<String> fields;
  final VoidCallback onFormClosed;

  const MyCustomForm({
    Key? key,
    required this.title,
    required this.fields,
    required this.onFormClosed,
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
    controllers =
        List.generate(widget.fields.length, (index) => TextEditingController());
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
          for (int i = 0; i < widget.fields.length; i++) 
            TextFormField(
              keyboardType: TextInputType.number,
              controller: controllers[i],
              decoration: InputDecoration(labelText: widget.fields[i]),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ${widget.fields[i]}';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controllers[2],
              decoration: InputDecoration(labelText: widget.fields[2]),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ${widget.fields[1]}';
                }
                return null;
              },
            ),

          ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
              storeData(); // Call storeData to store form data
              _formKey.currentState!.reset();
              widget.onFormClosed();
              }
            },
          ),
          ElevatedButton(
            child: const Text("Go back"),
            onPressed: () {
              widget.onFormClosed(); // Notify that the form is closed
            },
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
}
}