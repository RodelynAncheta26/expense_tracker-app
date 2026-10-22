import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/models/expense.dart';
import 'package:personal_expense_tracker/models/category.dart';

import 'package:personal_expense_tracker/services/supabase_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  List<Expense> _expenses = [];
  List<Category> _categories = [];

  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  List<Category> get category => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // get total expenses
  double get totalExpenses {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // get expenses by date range
  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses.where((expense) {
      return expense.date.isAfter(start.subtract(Duration(days: 1))) &&
          expense.date.isBefore(end.add(Duration(days: 1)));
    }).toList();
  }

  // get expenses by category
  List<Expense> getExpensesByCategory(String categoryId) {
    return _expenses
        .where((expense) => expense.categoryId == categoryId)
        .toList();
  }

  // get category by ID
  Category? getCategoryById(String? categoryId) {
    if (categoryId == null) return null;
    try {
      return _categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.wait([
        loadCategories(),
        loadExpenses(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadExpenses() async {
    try {
      _expenses = await _supabaseService.getExpenses();
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load expenses: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _supabaseService.getCategories();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load categories: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final newExpense = await _supabaseService.addExpense(expense);
      _expenses.insert(0, newExpense);
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add expense: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _supabaseService.deleteExpense(expenseId);
      _expenses.removeWhere((expense) => expense.id == expenseId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete expense: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _supabaseService.updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
        _expenses.sort((a, b) => b.date.compareTo(a.date));
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update expense: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      final newCategory = await _supabaseService.addCategory(category);
      _categories.add(newCategory);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add category: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _supabaseService.deleteCategory(categoryId);
      _categories.removeWhere((category) => category.id == categoryId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete category: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _supabaseService.updateCategory(category);
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update category: $e';
      notifyListeners();
      rethrow;
    }
  }

  void clearData() {
    _expenses = [];
    _categories = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}


