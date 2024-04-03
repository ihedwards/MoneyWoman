import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Income extends StatefulWidget {
  final Function(List<Map<String, String>>) updateTableData;

  const Income({Key? key, required this.updateTableData}) : super(key: key);

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  late SharedPreferences _prefs;
  List<Map<String, String>> _tableData = [];
  bool _isFormVisible = false;
  bool _prefsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _retrieveData(); // Wait for SharedPreferences data retrieval
    setState(() {
      _prefsInitialized = true;
    });
  }

  Future<void> _retrieveData() async {
    final String? jsonData = _prefs.getString('income_data');
    if (jsonData != null) {
      final decodedData = jsonDecode(jsonData);
      if (decodedData is List<dynamic>) {
        setState(() {
          _tableData = List<Map<String, String>>.from(decodedData.map((item) =>
              item is Map<String, dynamic>
                  ? item.map((key, value) => MapEntry(key, value.toString()))
                  : Map<String, String>.from({})));
        });
      }
    }
  }

  Future<void> _saveData() async {
    final String jsonData = jsonEncode(_tableData);
    await _prefs.setString('income_data', jsonData);
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
      title: const Text('Income'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                _toggleFormVisibility();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(_isFormVisible ? 'Cancel Income' : 'Add Income'),
            ),
          ),
        ),
      ],
    ),
    body: _prefsInitialized ? _buildBody() : _buildLoadingIndicator(),
  );
}


  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isFormVisible)
            MyCustomForm(
              title: '',
              fields: const ['When', 'Amount', 'Where'],
              onFormClosed: _toggleFormVisibility,
              onFormSubmitted: (data) {
                _addNewData(data);
              }, tital: '',
            ),
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
                    return DataCell(Text(data[key] ?? ''));
                  }).toList(),
                );
              }).toList(),
            ),
          if (_tableData.isEmpty && !_isFormVisible)
            const Center(
              child: Text('No Income Data Available'),
            ),
          
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
