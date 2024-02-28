import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

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
                MyCustomForm( //_TypeError (type 'Null) is not a subtype of type 'Widget'
                  title: 'Expenses',
                  fields: const ['Date', 'Amount Spent', 'Where'],
                  onFormClosed: () {
                  setState(() {
                    _toggleFormVisibility();
                    showButton();
                  });
                }, tital: '',
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
} 
  // ignore: non_constant_identifier_names, must_be_immutable
class MyCustomForm extends StatefulWidget {
  final String tital;
  final List<String> fields;
  final VoidCallback onFormClosed;
  
  // ignore: prefer_typing_uninitialized_variables
  var title;
  
   MyCustomForm({
    super.key,
    required this.title,
    required this.fields,
    required this.onFormClosed, required this.tital,
  });
@override
MyCustomFormState createState() => MyCustomFormState();
}