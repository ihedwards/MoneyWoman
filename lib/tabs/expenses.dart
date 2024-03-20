import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Map<String, String>> tableData = [];
  bool showForm = false;

  void _toggleFormVisibility() {
    setState(() {
      showForm = !showForm;
    });
  }

  void _addExpense(Map<String, String> expenseData) {
    setState(() {
      tableData.add(expenseData);
      _toggleFormVisibility(); // Close the form after adding expenseData
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: 
              _toggleFormVisibility,
              child: Text(showForm ? 'Hide Form' : 'Add Expense'),
            ),
            if (showForm)
              MyCustomForm(
                title: 'Expense Details',
                fields: const ['Date', 'Amount Spent', 'Where'],
                onFormClosed: _toggleFormVisibility,
                onFormSubmitted: _addExpense, tital: '',
              ),
            if (tableData.isNotEmpty || tableData.isEmpty)
              DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Amount Spent')),
                  DataColumn(label: Text('Where')),
                ],
                rows: tableData.map((expense) {
                  return DataRow(cells: [
                    DataCell(Text(expense['Date'] ?? '')),
                    DataCell(Text(expense['Amount Spent'] ?? '')),
                    DataCell(Text(expense['Where'] ?? '')),
                  ]);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
