//allows user_form to reference/use/know things in material.dart and import outside info
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'dart:convert'; //json conversion class

class MyCustomForm extends StatefulWidget {
  final String title;
  final List<String> fields;
  final VoidCallback onFormClosed;
  final void Function(Map<String, String> expenseData) onFormSubmitted;

  const MyCustomForm({ //requirements for custom form. Requirements never change
    super.key,
    required this.title,
    required this.fields,
    required this.onFormClosed,
    required this.onFormSubmitted, required String tital, //tital thingy, i honestly think it supposed to say title but it works soooooo
  });

  @override
  MyCustomFormState createState() => MyCustomFormState(); //creating state
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> controllers; //late = non-nullable variable will be initialized later. prevents code from getting mad at me
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
    prefs = await SharedPreferences.getInstance(); //prefs = wait to do sharedpreferences.getinstance until some other async operation is complete
  }

  @override
  void dispose() {  // Dispose of TextEditingController instances
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
          Padding( //spacing of form
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text( //word and how the words look in the form
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
            validator: (value) { //entire form must be filled out before submitting
              if (value == null || value.isEmpty) {
                return 'Please enter $field';
              }
              return null;
            },
          )),
          ElevatedButton( //creates submit button
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await storeData(); // Await the async method call to store the data
                _formKey.currentState!.reset(); //form 'empties' and the button disappears when submitted
                widget.onFormClosed();
              }
            },
            child: const Text('Submit'), //text for the form
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
      String jsonData = jsonEncode(data); //convert the input into json
      await prefs.setString(widget.title, jsonData);
      widget.onFormSubmitted(data);
    } catch (error) {
      // Handle error, if any
    }
  }
}
