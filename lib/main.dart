import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full Stack Programming Assistance',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'MoneyWoman'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Income(),
    const Data(),
    const Expenses(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.data_array), label: 'Data'),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), label: 'Income'),
        ],
      ),
    );
  }
}

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  bool showForm = false;

  void _toggleFormVisibility() {
    setState(() {
      showForm = !showForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _toggleFormVisibility,
                  child: const Text('Add Income'),
                ),
                if (showForm)
                  MyCustomForm(
                    title: 'Income',
                    fields: const ['Date', 'Amount Spent', 'Where'],
                    onFormClosed: _toggleFormVisibility,
                  ),
              ],
            ),
          ),
        ));
  }
}

class Data extends StatelessWidget {
  const Data({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'History',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  bool showForm = false;

  void _toggleFormVisibility() {
    setState(() {
      showForm = !showForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _toggleFormVisibility,
                child: const Text('Add Expense'),
              ),
              if (showForm)
                MyCustomForm(
                  title: 'Expenses',
                  fields: const ['Date', 'Amount Earned', 'Where'],
                  onFormClosed: _toggleFormVisibility,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        child: Column(children: <Widget>[
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
              controller: controllers[i],
              decoration: InputDecoration(labelText: widget.fields[i]),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ${widget.fields[i]}';
                }
                return null;
              },
            ),
          ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final data = {
                  for (int i = 0; i < widget.fields.length; i++)
                    widget.fields[i]: controllers[i].text,
                };
                setState(() {
                  tableData.add(data);
                });
                _formKey.currentState!.reset();
              }
            },
          ),
          ElevatedButton(
            child: const Text("Go back"),
            onPressed: () {
              setState(() {});
              widget.onFormClosed(); // Notify that the form is closed
            },
          ),
          if (tableData.isNotEmpty)
            DataTable(
              columns: widget.fields.map<DataColumn>((String field) {
                return DataColumn(label: Text(field));
              }).toList(),
              rows: tableData.map<DataRow>((Map<String, String> data) {
                return DataRow(cells: [
                  for (int i = 0; i < widget.fields.length; i++)
                    DataCell(Text(data[widget.fields[i]]!)),
                ]);
              }).toList(), // Convert the Iterable<DataRow> to List<DataRow>
            )
        ]));
  }
}
