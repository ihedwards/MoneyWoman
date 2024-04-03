import 'package:flutter/material.dart';
import 'package:flutter_money_working/tabs/income.dart';
import 'package:flutter_money_working/tabs/expenses.dart';
import 'package:flutter_money_working/tabs/data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ella is trying her best',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'MoneyWoman'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget> _pages;

  List<Map<String, String>> tableData = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      Expenses(updateTableData: updateTableData),
      const Data(),
      Income(updateTableData: updateTableData),

    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 200, 173, 207),
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
            icon: Icon(Icons.attach_money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_array),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Income',
          ),
        ],
      ),
    );
  }

  void updateTableData(List<Map<String, String>> newData) {
    setState(() {
      tableData = newData;
    });
  }
}
