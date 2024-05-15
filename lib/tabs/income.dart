//ALL THE IMPORTS allow for the files to interact with one another/pull functions and data from one another. Also allows to import classes like dart: convert.
import 'package:flutter/material.dart';
import 'package:flutter_money_working/tabs/data.dart'; 
import 'package:flutter_money_working/user_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; //used to convert data to json and back
import 'package:intl/intl.dart';

class Income extends StatefulWidget {
  final Function(List<Map<String, String>>) updateTableData;

  const Income({super.key, required this.updateTableData});

  @override
  // ignore: library_private_types_in_public_api
  _IncomeState createState() => _IncomeState(); //creates state
}

class _IncomeState extends State<Income> {
  late SharedPreferences _prefs;
  List<Map<String, String>> _tableData = [];
  bool _isFormVisible = false; //initialized form visibility and prefsinitialized to be false. no form and no shared preferences initialization
  bool _prefsInitialized = false;
  final DataComparison _dataComparison = DataComparison(); //creating datacomparison

  @override
  void initState() { //how the initSharedPreferences are initialized
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async { //async = can preform tasks that take longer to complete, ie fetching data
    _prefs = await SharedPreferences.getInstance();
    await _retrieveData(); // Wait for SharedPreferences data retrieval
    setState(() { //setting state to allow the shared_preferences to be initialized
      _prefsInitialized = true;
    });
    _dataComparison.compareData(); //call compareData when SharedPreferences in initialized
  }

  Future<void> _retrieveData() async {
    final String? jsonData = _prefs.getString('income_data');
    if (jsonData != null) { //if the data is in json 
      final decodedData = jsonDecode(jsonData); //decode the data from json
      if (decodedData is List<dynamic>) { //data is in a scrollable list
        setState(() {  
          _tableData = List<Map<String, String>>.from(decodedData.map((item) => //map dynamic string to key
              item is Map<String, dynamic>
                  ? item.map((key, value) => MapEntry(key, value.toString()))
                  : Map<String, String>.from({})));
        });
      }
    }
  }

  Future<void> _saveData() async { //save data onto table
    final String jsonData = jsonEncode(_tableData); //endcode the data into json
    await _prefs.setString('income_data', jsonData); //await preferences
  }


void _addNewData(Map<String, String> newData) {
  final amountString = newData['Amount'] ?? '0.0';   // Get the amount string from newData

  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');   // Create a NumberFormat instance for currency parsing

  final amount = currencyFormat.parse(amountString);   // Parse the amount string using the NumberFormat instance

  final parsedAmount = amount.toDouble(); // Convert the parsed amount to a double

  newData['Amount'] = parsedAmount.toStringAsFixed(2);   // Update the newData map with the parsed amount

  setState(() { 
    _tableData.add(newData); //adding data to _tableData / the table in general
    _saveData(); //saving the data
  });
  widget.updateTableData(_tableData); //updates it
}

  void _toggleFormVisibility() {
    setState(() {
      _isFormVisible = !_isFormVisible; //allows form to toggle between visibility and disappearing.
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Income'), //title in the top left corner of screen. title of whole tab
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox( //W*H for the button
            width: 150,
            height: 40,
            child: ElevatedButton( //creates an elevated button
              onPressed: () { //when pressed the form toggles. can become visible or dissapear
                _toggleFormVisibility();
              },
              style: ElevatedButton.styleFrom( //style of the button. changing style of the border
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder( //rounds the edges or the button
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(_isFormVisible ? 'Cancel Income' : 'Add Income'), //toggles between the text depending on form visibility
            ),
          ),
        ),
      ],
    ),
    body: _prefsInitialized ? _buildBody() : _buildLoadingIndicator(), //same thing as expenses
  );
}


  Widget _buildBody() {
    return SingleChildScrollView( //can scroll
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isFormVisible) //when form is visible call MyCustomForm from the user_form.dart
            MyCustomForm( 
              title: '', //empty title = added empty line = formating
              fields: const ['Date', 'Amount', 'Where'], //creates the fields. different from expenses.dart
              onFormClosed: _toggleFormVisibility, //when the onFormClosed is called, call _toggleFormVisibility to actually close it
              onFormSubmitted: (data) { //when form is submitted add data
                _addNewData(data);
              }, 
            ),
          if (!_isFormVisible && _tableData.isNotEmpty) //when the form is not visible and the table is showing
            DataTable( //how to table appears and the formatting. how data is added to the bottom of the table.
              columns: _tableData.isNotEmpty
                  ? _tableData.first.keys.map((String key) {
                      return DataColumn(label: Text(key));
                    }).toList()
                  : [],
              rows: _tableData.map((Map<String, String> data) {
                return DataRow(
                  cells: data.keys.map((String key) {
                    return DataCell(Text(data[key] ?? ''));
                  }).toList(),
                );
              }).toList(),
            ),
          if (_tableData.isEmpty && !_isFormVisible) //when the table is empty user sees following text
            const Center( //make it look pretty
              child: Padding(
              padding: EdgeInsets.all(125.0),
              child: 
                Text('No Income Data Available', //what you initially see on the income page
                style: TextStyle(fontSize: 20.0),
            ))),
          
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
