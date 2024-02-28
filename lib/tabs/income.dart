import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  bool showForm = false;
  bool isButtonVisible = true;

  bool previousShowForm = false; // Initialize with some default value

  void _noFormVisibility() {
    setState(() {
      previousShowForm = showForm; // Store the previous state
      showForm = !showForm; // Toggle the state
    });
  }

  void _showFormVisibility(){
    setState(() {
      showForm = true; // Set showForm to true
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
                  _showFormVisibility();
                  hideButton();
                },
                child: const Text('Add Income'),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Total Earned:',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
            if (showForm)
              MyCustomForm(
                title: 'Income',
                fields: const ['Date', 'Amount Earned', 'Where'],
                onFormClosed: () {
                  setState(() {
                    _import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  bool showForm = false;
  bool isButtonVisible = true;

  bool previousShowForm = false; // Initialize with some default value

  void _noFormVisibility() {
    setState(() {
      previousShowForm = showForm; // Store the previous state
      showForm = !showForm; // Toggle the state
    });
  }

  void _showFormVisibility() {
    setState(() {
      showForm = true; // Set showForm to true
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
                  _showFormVisibility();
                  hideButton();
                },
                child: const Text('Add Income'),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Total Earned:',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
            if (showForm)
              MyCustomForm(
                title: 'Income',
                fields: const ['Date', 'Amount Earned', 'Where'],
                onFormClosed: () {
                  setState(() {
                    _noFormVisibility();
                    showButton();
                  });
                },
                tital: '', // Ensure this parameter is correctly spelled as 'title'
              ),
            Visibility(
              visible: true,import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  bool showForm = false;
  bool isButtonVisible = true;

  bool previousShowForm = false; // Initialize with some default value

  void _noFormVisibility() {
    setState(() {
      previousShowForm = showForm; // Store the previous state
      showForm = !showForm; // Toggle the state
    });
  }

  void _showFormVisibility() {
    setState(() {
      showForm = true; // Set showForm to true
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
                  _showFormVisibility();
                  hideButton();
                },
                child: const Text('Add Income'),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Total Earned:',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
            if (showForm)
              MyCustomForm(
                title: 'Income',
                fields: const ['Date', 'Amount Earned', 'Where'],
                onFormClosed: () {
                  setState(() {
                    _noFormVisibility();
                    showButton();
                  });
                },
                tital: '', // Ensure this parameter is correctly spelled as 'title'
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
import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  bool showForm = false;
  bool isButtonVisible = true;

  bool previousShowForm = false; // Initialize with some default value

  void _noFormVisibility() {
    setState(() {
      previousShowForm = showForm; // Store the previous state
      showForm = !showForm; // Toggle the state
    });
  }

  void _showFormVisibility() {
    setState(() {
      showForm = true; // Set showForm to true
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
                  _showFormVisibility();
                  hideButton();
                },
                child: const Text('Add Income'),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Total Earned:',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
            if (showForm)
              MyCustomForm(
                title: 'Income',
                fields: const ['Date', 'Amount Earned', 'Where'],
                onFormClosed: () {
                  setState(() {
                    _noFormVisibility();
                    showButton();
                  });
                },
                tital: '', // Ensure this parameter is correctly spelled as 'title'
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
import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  bool showForm = false;
  bool isButtonVisible = true;

  bool previousShowForm = false; // Initialize with some default value

  void _noFormVisibility() {
    setState(() {
      previousShowForm = showForm; // Store the previous state
      showForm = !showForm; // Toggle the state
    });
  }

  void _showFormVisibility() {
    setState(() {
      showForm = true; // Set showForm to true
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
                  _showFormVisibility();
                  hideButton();
                },
                child: const Text('Add Income'),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Total Earned:',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
            if (showForm)
              MyCustomForm(
                title: 'Income',
                fields: const ['Date', 'Amount Earned', 'Where'],
                onFormClosed: () {
                  setState(() {
                    _noFormVisibility();
                    showButton();
                  });
                },
                tital: '', // Ensure this parameter is correctly spelled as 'title'
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
import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  bool showForm = false;
  bool isButtonVisible = true;

  bool previousShowForm = false; // Initialize with some default value

  void _noFormVisibility() {
    setState(() {
      previousShowForm = showForm; // Store the previous state
      showForm = !showForm; // Toggle the state
    });
  }

  void _showFormVisibility() {
    setState(() {
      showForm = true; // Set showForm to true
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
                  _showFormVisibility();
                  hideButton();
                },
                child: const Text('Add Income'),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Total Earned:',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
            if (showForm)
              MyCustomForm(
                title: 'Income',
                fields: const ['Date', 'Amount Earned', 'Where'],
                onFormClosed: () {
                  setState(() {
                    _noFormVisibility();
                    showButton();
                  });
                },
                tital: '', // Ensure this parameter is correctly spelled as 'title'
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
import 'package:flutter/material.dart';
import 'package:flutter_money_working/user_form.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  bool showForm = false;
  bool isButtonVisible = true;

  bool previousShowForm = false; // Initialize with some default value

  void _noFormVisibility() {
    setState(() {
      previousShowForm = showForm; // Store the previous state
      showForm = !showForm; // Toggle the state
    });
  }

  void _showFormVisibility() {
    setState(() {
      showForm = true; // Set showForm to true
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
                  _showFormVisibility();
                  hideButton();
                },
                child: const Text('Add Income'),
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Total Earned:',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
            if (showForm)
              MyCustomForm(
                title: 'Income',
                fields: const ['Date', 'Amount Earned', 'Where'],
                onFormClosed: () {
                  setState(() {
                    _noFormVisibility();
                    showButton();
                  });
                },
                tital: '', // Ensure this parameter is correctly spelled as 'title'
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
FormVisibility();
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

class FormVisibility {
}  
  // ignore: non_constant_identifier_names, must_be_immutable
class MyCustomForm extends StatefulWidget {
  final String tital;
  final List<String> fields;
  final VoidCallback onFormClosed;
  
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
