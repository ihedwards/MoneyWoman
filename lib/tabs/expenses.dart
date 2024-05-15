import 'package:flutter/material.dart'; //imports other files, without it all the files would be isolated and not able to reference each other
import 'package:flutter_money_working/user_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Expenses extends StatefulWidget {
  final Function(List<Map<String, String>>) updateTableData;

  const Expenses({super.key, required this.updateTableData});

  @override
  // ignore: library_private_types_in_public_api
  _ExpensesState createState() => _ExpensesState(); //creates state 
}

class _ExpensesState extends State<Expenses> {
  late SharedPreferences _prefs;
  List<Map<String, String>> _tableData = []; //testing commit 
  bool _isFormVisible = false; //form is not initially visible
  bool _prefsInitialized = false; //shared_preferences are not initialized

  @override
  void initState() { 
    super.initState();
    _initSharedPreferences(); //how shared_preferences are initialized
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _retrieveData(); // Wait for SharedPreferences data retrieval
    setState(() {
      _prefsInitialized = true; //shared_preferences are initialized
    });
  }

  Future<void> _retrieveData() async { //retrieves data
  final String? jsonData = _prefs.getString('expenses_data');
  if (jsonData != null) { //if data is jsonData run
    final decodedData = jsonDecode(jsonData); //decodes json data
    if (decodedData is List<dynamic>) { 
      setState(() {//setting the state
        _tableData = List<Map<String, String>>.from(decodedData.map((item) => //adds decoded data to table
            item is Map<String, dynamic>
                ? item.map((key, value) => MapEntry(key, value.toString()))
                : Map<String, String>.from({})));
      });
    }
  }
}

  Future<void> _saveData() async {
    final String jsonData = jsonEncode(_tableData); //encodes data into json. saving data
    await _prefs.setString('expenses_data', jsonData); 
  }


void _addNewData(Map<String, String> newData) {
  final amountString = newData['Amount'] ?? '00.0';   // Get the amount string from newData

  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');   // Create a NumberFormat instance for currency parsing

  final amount = currencyFormat.parse(amountString);   // Parse the amount string using the NumberFormat instance

  final parsedAmount = amount.toDouble();  // Convert the parsed amount to a double

  newData['Amount'] = parsedAmount.toStringAsFixed(2);   // Update the newData map with the parsed amount

  setState(() { //used to rebuild UI after updating state
    _tableData.add(newData); //add new data to _tableData
    _saveData(); //saves the data
  });
  widget.updateTableData(_tableData);
}



  void _toggleFormVisibility() { //sets up toggleformvisibility, goes from visible to not.
    setState(() {
      _isFormVisible = !_isFormVisible; //switches from visible to not visible, when called the forms visibility switches.
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Expenses'), //title of the tab at the top left of the screen
      actions: [
        Padding( // prevents the button from taking up the whole page/adds white space between things/allows me to format button easier
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox( //size of the button WxH
            width: 150, 
            height: 40,
            child: ElevatedButton( //creating an elevated button. button is slightly raised
              onPressed: () { //when the button is pressed the following action occurs
                _toggleFormVisibility(); //form either becomes visible or disappears.
              },
              style: ElevatedButton.styleFrom( //style of the edges of the button/outline
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder( //makes the corners of the button rounded
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(_isFormVisible ? 'Cancel Expenses' : 'Add Expenses'), //text on button. changes depending on weather the form is visible or not
            ),
          ),
        ),
      ],
    ),
    body: _prefsInitialized ? _buildBody() : _buildLoadingIndicator(), //sets body of the scaffold widget based on if _prefsInitialized occurs, if so displays _buildBody, if not displays _buildLoadingIndicator
  );
}

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isFormVisible)
            MyCustomForm( //form called from the user_form.dart file
              title: '', //no title for the form, adds an empty line
              fields: const ['Date', 'Amount', 'Where'], //specific fields/input the form is asking for
              onFormClosed: _toggleFormVisibility, //form disappears when the form is closed or submitted
              onFormSubmitted: (data) { //when the firm is submitted new data is added to the table
                _addNewData(data);
              },
            ),
          if (!_isFormVisible && _tableData.isNotEmpty) //if the form is visible and there is data in the table
            if (!_isFormVisible && _tableData.isNotEmpty)
              DataTable(
                columns: _tableData.isNotEmpty
                    ? _tableData.first.keys.map((String key) {
                        return DataColumn(label: Text(key));
                      }).toList()
                    : [],
                rows: _tableData.map((Map<String, String> data) {
                  return DataRow(
                    cells: data.keys.map((String key) {
                      if (key == 'Amount') {
                        // Format the amount as currency
                        final amount = double.tryParse(data[key] ?? '0.0') ?? 0.0;
                        final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
                        return DataCell(Text(currencyFormat.format(amount)));
                      } else {
                        return DataCell(Text(data[key] ?? ''));
                      }
                    }).toList(),
                  );
                }).toList(),
              ),
          if (_tableData.isEmpty && !_isFormVisible) //when there is not data and table = no table is shown = text appears to user
             const Center( //making it all look pretty
              child: Padding(
              padding: EdgeInsets.all(125.0),
              child: 
                Text('No Expense Data Available', //text you see on the screen
                style: TextStyle(fontSize: 20.0),
            ))),
    
          
      ],
      ),
    );
  }

  Widget _buildLoadingIndicator() { //display loading indicator
    return const Center(
      child: CircularProgressIndicator(), //circle thingy you see when stuff loads
    );
  }
}
