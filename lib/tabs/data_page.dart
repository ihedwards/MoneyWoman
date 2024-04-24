import 'package:flutter/material.dart';
import 'package:flutter_money_working/tabs/data.dart'; // Import your DataComparison class here

class DataPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DataComparison().compareData(), // Invoke compareData method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Display the comparison result
        return Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            snapshot.data ?? '', // Display the result from the future
            style: const TextStyle(fontSize: 18.0),
          ),
        );
      },
    );
  }
}
