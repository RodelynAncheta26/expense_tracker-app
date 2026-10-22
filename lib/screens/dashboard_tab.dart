import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_expense_tracker/providers/expense_provider.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        if (expenseProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final now = DateTime.now();
        final thisMonth = expenseProvider.getExpensesByDateRange(
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 0),
        );
        final thisWeek = expenseProvider.getExpensesByDateRange(
          now.subtract(Duration(days: now.weekday - 1)),
          now,
        );
        final today = expenseProvider.getExpensesByDateRange(
          DateTime(now.year, now.month, now.day),
          DateTime(now.year, now.month, now.day, 23, 59),
        );

        final totalMonth = thisMonth.fold(0.0, (sum, e) => sum + e.amount);
        final totalWeek = thisWeek.fold(0.0, (sum, e) => sum + e.amount);
        final totalToday = today.fold(0.0, (sum, e) => sum + e.amount);

        Map<String, double> categoryTotals = {};
        for (var expense in expenseProvider.expenses) {
          final cat = expenseProvider.getCategoryById(expense.categoryId);
          final catName = cat?.name ?? 'Uncategorized';
          categoryTotals[catName] =
              (categoryTotals[catName] ?? 0) + expense.amount;
        }

        return RefreshIndicator(
          onRefresh: () => expenseProvider.loadExpenses(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6366F1),
                      Color.fromARGB(255, 48, 50, 159),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Expense',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${expenseProvider.totalExpenses.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${expenseProvider.expenses.length} transactions',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Today',
                      amount: totalToday,
                      icon: Icons.today,
                      color: Colors.indigo,
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'This Week',
                      amount: totalWeek,
                      icon: Icons.date_range,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'This Month',
                amount: totalMonth,
                icon: Icons.calendar_month,
                color: Colors.orange,
                wide: true,
              ),

              SizedBox(height: 24),
              if (true) ...[
                Text(
                  'Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: PieChart(PieChartData()),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final bool wide;

  const _StatCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
