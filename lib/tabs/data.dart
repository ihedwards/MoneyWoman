import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ComparisonResult {
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
    return [];
  }

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
    return [];
  }

  Future<ComparisonResult> compareData() async {
    List<Map<String, String>> incomeData = await retrieveIncomeData();
    List<Map<String, String>> expensesData = await retrieveExpensesData();

    double totalIncome = _calculateTotalAmount(incomeData);
    double totalExpenses = _calculateTotalAmount(expensesData);

    String result;
    if (totalIncome > totalExpenses) {
      result = 'Income is greater than expenses.';
    } else if (totalIncome < totalExpenses) {
      result = 'Expenses are greater than income.';
    } else if (totalIncome == totalExpenses && totalIncome != 0) {
      result = 'Income and expenses are equal.';
    } else {
      result = 'No data available';
    }

    return ComparisonResult(
      result: result,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
    );
  }

  double _calculateTotalAmount(List<Map<String, String>> data) {
    double totalAmount = 0;
    for (var entry in data) {
      totalAmount += double.tryParse(entry['Amount'] ?? '0') ?? 0;
    }
    return totalAmount;
  }
}
