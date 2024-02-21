import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ExpensesState createState() => _ExpensesState();

}

class _ExpensesState extends State<Expenses> {
  bool showForm = false;
    bool isButtonVisible = true;

  void _toggleFormVisibility() {
    setState(() {
      showForm = !showForm;
    });
  }
  void hideButton() {
    setState(() {
      isButtonVisible = false;
    });
  }

  void showButton() {
    setState(() {
      isButtonVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            children: [
               Visibility(
              visible: isButtonVisible,
              child: ElevatedButton(
                onPressed: () {
                  _toggleFormVisibility();
                  hideButton();
                },
                child: const Text('Add Expnese'),
              )
              ),
               RichText(
                text: TextSpan(
                  text: 'Total Spent:',
                  style: DefaultTextStyle.of(context).style,
                )
              ),
              if (showForm)
                MyCustomForm(
                  title: 'Expenses',
                  fields: ['Date', 'Amount Spent', 'Where'],
                  onFormClosed: () {
                  setState(() {
                    _toggleFormVisibility();
                    showButton();
                  });
                },
              ),
              Visibility(
                visible: true,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Amount Earned')),
                    DataColumn(label: Text('Where')),
                  ],
                  rows: const [],
                ),
              ),
            ],
          ),
        ),
      );
  }
  
  // ignore: non_constant_identifier_names
MyCustomForm({required String title, required List<String> fields, required void Function() onFormClosed}) {}
}