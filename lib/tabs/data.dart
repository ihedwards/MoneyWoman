import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataComparison {
  // Method to retrieve income data from SharedPreferences
  Future<List<Map<String, String>>> retrieveIncomeData() async {
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
    return []; // Return an empty list if no data found
  }
  
  // Method to retrieve expenses data from SharedPreferences
  Future<List<Map<String, String>>> retrieveExpensesData() async {
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
    return []; // Return an empty list if no data found
  }

  // Method to compare income and expenses data
  Future<String> compareData() async {
    List<Map<String, String>> incomeData = await retrieveIncomeData();
    List<Map<String, String>> expensesData = await retrieveExpensesData();

    // Compare data logic
    // For example, calculate total income and total expenses
    double totalIncome = _calculateTotalAmount(incomeData);
    double totalExpenses = _calculateTotalAmount(expensesData);

    // Compare the total income and expenses
    if (totalIncome > totalExpenses) {
      print = 'Income is greater than expenses.';
    } else if (totalIncome < totalExpenses) {
      print 'Expenses are greater than income.';
    } else {
      return 'Income and expenses are equal.';
    }
  }

  // Helper method to calculate total amount from data entries
  double _calculateTotalAmount(List<Map<String, String>> data) {
    double totalAmount = 0;
    for (var entry in data) {
      totalAmount += double.tryParse(entry['Amount'] ?? '0') ?? 0;
    }
    return totalAmount;
  }
}
