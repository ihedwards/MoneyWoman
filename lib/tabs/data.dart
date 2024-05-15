import 'package:shared_preferences/shared_preferences.dart'; //imported stuff, needed to work
import 'dart:convert';

class ComparisonResult { //creating stuff needed for comparing values
  final String result;
  final double totalIncome;
  final double totalExpenses;

  ComparisonResult({
    required this.result,
    required this.totalIncome,
    required this.totalExpenses,
  });
}

class DataComparison {
  Future<List<Map<String, String>>> retrieveIncomeData() async { //bunch of needed but confusing things. Having to do with decoding json with the shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString('income_data');
    if (jsonData != null) {
      final decodedData = jsonDecode(jsonData);
      if (decodedData is List<dynamic>) {
        return List<Map<String, String>>.from(decodedData.map((item) =>
            item is Map<String, dynamic>
                ? item.map((key, value) =>
                    MapEntry(key, value.toString()))
                : Map<String, String>.from({})));
      }
    }
    return [];
  }

  Future<List<Map<String, String>>> retrieveExpensesData() async { //getting all the data and decoding it
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString('expenses_data');
    if (jsonData != null) {
      final decodedData = jsonDecode(jsonData);
      if (decodedData is List<dynamic>) {
        return List<Map<String, String>>.from(decodedData.map((item) =>
            item is Map<String, dynamic>
                ? item.map((key, value) =>
                    MapEntry(key, value.toString()))
                : Map<String, String>.from({})));
      }
    }
    return [];
  }

  Future<ComparisonResult> compareData() async { //comparison betweeen data. 
    List<Map<String, String>> incomeData = await retrieveIncomeData();
    List<Map<String, String>> expensesData = await retrieveExpensesData();

    double totalIncome = _calculateTotalAmount(incomeData);
    double totalExpenses = _calculateTotalAmount(expensesData);

    String result; //actual comparisons using if else statements
    if (totalIncome > totalExpenses) {
      result = 'Income is greater than expenses.';
    } else if (totalIncome < totalExpenses) {
      result = 'Expenses are greater than income.';
    } else if (totalIncome == totalExpenses && totalIncome != 0) {
      result = 'Income and expenses are equal.';
    } else {
      result = 'No data available';
    }

    return ComparisonResult( //used in data_page.dart
      result: result,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
    );
  }

  double _calculateTotalAmount(List<Map<String, String>> data) { //the math is mathing. the math behind it
    double totalAmount = 0;
    for (var entry in data) {
      totalAmount += double.tryParse(entry['Amount'] ?? '0') ?? 0;
    }
    return totalAmount;
  }
}
