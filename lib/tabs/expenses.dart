import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Expenses extends StatefulWidget {
  final Function(List<Map<String, String>>) updateTableData;

  const Expenses({required this.updateTableData});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  late SharedPreferences _prefs;
  List<Map<String, String>> _tableData = [];
  bool _isFormVisible = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _retrieveData(); // Retrieve data when SharedPreferences is initialized
  }

  Future<void> _retrieveData() async {
    final String? jsonData = _prefs.getString('expenses_data');
    if (jsonData != null) {
      final List<dynamic> decodedData = jsonDecode(jsonData);
      setState(() {
        _tableData = List<Map<String, String>>.from(decodedData);
      });
    }
  }

  Future<void> _saveData() async {
    final String jsonData = jsonEncode(_tableData);
    await _prefs.setString('expenses_data', jsonData);
  }

  void _addNewData(Map<String, String> newData) {
    setState(() {
      _tableData.add(newData);
      _saveData(); // Save data whenever it's updated
    });
    widget.updateTableData(_tableData); // Update data in parent widget
  }

  void _toggleFormVisibility() {
    setState(() {
      _isFormVisible = !_isFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isFormVisible)
              MyCustomForm(
                title: 'Expense Form',
                fields: ['When', 'Amount', 'Where'], // Adjust with your fields
                onFormClosed: _toggleFormVisibility,
                onFormSubmitted: (data) {
                  _addNewData(data);
                  _toggleFormVisibility();
                }, tital: '',
              ),
            if (_tableData.isNotEmpty)
              DataTable(
                columns: _tableData.isNotEmpty
                    ? _tableData.first.keys.map((String key) {
                        return DataColumn(label: Text(key));
                      }).toList()
                    : [], // Use keys from first map in _tableData as columns
                rows: _tableData.map((Map<String, String> data) {
                  return DataRow(
                    cells: data.keys.map((String key) {
                      return DataCell(Text(data[key] ?? ''));
                    }).toList(),
                  );
                }).toList(),
              ),
            if (_tableData.isEmpty && !_isFormVisible)
              Center(
                child: Text('No Expense Data Available'),
              ),
            ElevatedButton(
              onPressed: () {
                _toggleFormVisibility();
              },
              child: Text(_isFormVisible ? 'Cancel Expense' : 'Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
