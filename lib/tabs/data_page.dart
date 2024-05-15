import 'package:flutter/material.dart';
import 'package:flutter_money_working/tabs/data.dart'; // Import your DataComparison class here

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ComparisonResult>( //FutureBuilder builds UI based on latest snapshot of interaction with a 'future'
      future: DataComparison().compareData(),
      builder: (context, snapshot) { //creates widget tree based on the latest snapshot. Recieves 'BuildContext' and 'AsyncSnapshot' of data being fetched
        if (snapshot.connectionState == ConnectionState.waiting) { //error messages and extracting data from the snapshot
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final comparisonResult = snapshot.data!;
          Color textColor = comparisonResult.result == 'Income is greater than expenses.'  // Determine text color based on comparison result
              ? const Color.fromARGB(255, 53, 143, 56) // Green color for higher income
              : comparisonResult.result == 'Expenses are greater than income.'
                  ? const Color.fromARGB(255, 148, 60, 54) // Red color for higher expenses
                  : Colors.black; // Black for equal or no data

          return Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ //commented out code. if in tells comparison. ___ is greater than ___.
                  // Align(
                  //   alignment : Alignment.topCenter,
                  //   child: Text(
                  //       comparisonResult.result,
                  //       style: const TextStyle(fontSize: 18.0),
                  //     )),
                  //     const SizedBox(height: 20), // Add some space between other texts

                  Row( //formatting for text --> allows them to show up next to each other
                    children: [
                      const SizedBox(width: 20),
                      Text( //display expenses
                        'Total Expenses: ${comparisonResult.totalExpenses}', //list the value of the total expenses
                        style: TextStyle(fontSize: 18.0, color: textColor),
                      ),
                      const SizedBox(width: 110),
                      Text( //display income
                        'Total Income: ${comparisonResult.totalIncome}', //list the value fo the total income
                        style: TextStyle(fontSize: 18.0, color: textColor), //styles the text
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available')); //if else statement.. final one. if not these then this
        }
      },
    );
  }
}
