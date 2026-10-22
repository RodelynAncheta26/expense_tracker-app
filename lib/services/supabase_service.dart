import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category.dart';

import '../models/expense.dart';



class SupabaseService {

  final SupabaseClient _client = Supabase.instance.client;



  User? get currentUser => _client.auth.currentUser;



  // Sign up

  Future<AuthResponse> signUp({

    required String email,

    required String password,

    required String fullName,

  }) async {

    try {

      final response = await _client.auth.signUp(

        email: email,

        password: password,

          data: {'full_name': fullName},

      );

      if (response.user != null) {

      await _createDefaultCategories(response.user!.id);

    }

    return response;



    } catch (e) {

      throw Exception('Sign up failed: $e');

    }

  }



  Future<void> _createDefaultCategories(String userId) async {

    try {

      final defaultCategories = [

        {'user_id': userId, 'name': 'Food', 'icon': '🍔', 'color': '#FF5733'},

        {

          'user_id': userId,

          'name': 'Transport',

          'icon': '🚗',

          'color': '#33C1FF',

        },

        {

          'user_id': userId,

          'name': 'Entertainment',

          'icon': '🎬',

          'color': '#9D33FF',

        },

        {

          'user_id': userId,

          'name': 'Shopping',

          'icon': '🛍️',

          'color': '#FF33A8',

        },

        {'user_id': userId, 'name': 'Bills', 'icon': '💡', 'color': '#33FF57'},

        {'user_id': userId, 'name': 'Health', 'icon': '🏥', 'color': '#FF8C33'},

        {'user_id': userId, 'name': 'Other', 'icon': '📌', 'color': '#FCBAD3'},

      ];



      await _client.from('categories').insert(defaultCategories);

    } catch (e) {

      print('Error creating default categories: $e');

    }

  }



  // Sign In

  Future<AuthResponse> signIn({

    required String email,

    required String password,

  }) async {

    try {

      final response = await _client.auth.signInWithPassword(

        email: email,

        password: password,

      );

      return response;

    } catch (e) {

      throw Exception('Sign in failed: $e');

    }

  }



  // Sign Out

  Future<void> signOut() async {

    try {

      await _client.auth.signOut();

    } catch (e) {

      throw Exception('Sign out failed: $e');

    }

  }



  // Get categories

  Future<List<Category>> getCategories() async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      final response = await _client

          .from('categories')

          .select()

          .eq('user_id', userId)

          .order('created_at', ascending: true);



      return (response as List).map((json) => Category.fromJson(json)).toList();

    } catch (e) {

      throw Exception('Failed to fetch categories: $e');

    }

  }



  // add category

  Future<Category> addCategory(Category category) async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      final response = await _client

          .from('categories')

          .insert(category.toJson())

          .select()

          .single();



      return Category.fromJson(response);

    } catch (e) {

      throw Exception('Failed to add category: $e');

    }

  }



  // update category

  Future<void> updateCategory(Category category) async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      await _client

          .from('categories')

          .update(category.toJson())

          .eq('id', category.id!)

          .eq('user_id', userId);

    } catch (e) {

      throw Exception('Failed to update category: $e');

    }

  }



  // delete category

  Future<void> deleteCategory(String categoryId) async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      await _client

          .from('categories')

          .delete()

          .eq('id', categoryId)

          .eq('user_id', userId);

    } catch (e) {

      throw Exception('Failed to delete category: $e');

    }

  }



  Future<List<Expense>> getExpenses() async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      final response = await _client

          .from('expenses')

          .select()

          .eq('user_id', userId)

          .order('date', ascending: false);



      return (response as List).map((json) => Expense.fromJson(json)).toList();

    } catch (e) {

      throw Exception('Failed to fetch expenses: $e');

    }

  }



  // add expense

  Future<Expense> addExpense(Expense expense) async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      final response = await _client

          .from('expenses')

          .insert(expense.toJson())

          .select()

          .single();



      return Expense.fromJson(response);

    } catch (e) {

      throw Exception('Failed to add expense: $e');

    }

  }



  // update expense

  Future<void> updateExpense(Expense expense) async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      await _client

          .from('expenses')

          .update(expense.toJson())

          .eq('id', expense.id!)

          .eq('user_id', userId);

    } catch (e) {

      throw Exception('Failed to update expense: $e');

    }

  }



  // delete expense

  Future<void> deleteExpense(String expenseId) async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      await _client

          .from('expenses')

          .delete()

          .eq('id', expenseId)

          .eq('user_id', userId);

    } catch (e) {

      throw Exception('Failed to delete expense: $e');

    }

  }



  Future<List<Expense>> getExpensesByDateRange(

    DateTime startDate,

    DateTime endDate,

  ) async {

    try {

      final userId = currentUser?.id;

      if (userId == null) throw Exception('No authenticated user');



      final response = await _client

          .from('expenses')

          .select()

          .eq('user_id', userId)

          .gte('date', startDate.toIso8601String().split('T')[0])

          .lte('date', endDate.toIso8601String().split('T')[0])

          .order('date', ascending: false);



      return (response as List).map((json) => Expense.fromJson(json)).toList();

    } catch (e) {

      throw Exception('Failed to fetch expenses by date range: $e');

    }

  }

}