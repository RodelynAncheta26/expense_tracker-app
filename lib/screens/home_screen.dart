import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_expense_tracker/services/supabase_service.dart';
import 'package:personal_expense_tracker/providers/expense_provider.dart';
import 'package:personal_expense_tracker/screens/dashboard_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final _subsupabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Provider.of<ExpenseProvider>(context, listen: false).loadExpenses();
  }

  Future<void> _logout() async {
    try {
      await _subsupabaseService.signOut();
      if (!mounted) return;
      Provider.of<ExpenseProvider>(context, listen: false).clearData();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar( SnackBar(content: Text('Logout failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expense Tracker'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs:  [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Expense'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:  [DashboardTab(), Container()],
      ),
    );
  }
}