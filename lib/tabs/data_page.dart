import 'package:flutter/material.dart';
import 'package:flutter_money_working/tabs/data.dart';

class DataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataComparison().compareData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or any loading indicator
        }
        // You can return any widget here to display the comparison result
        return Container(
          child: const Text('Data Comparison'), // Example text widget
        );
      },
    );
  }
}
