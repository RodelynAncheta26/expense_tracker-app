import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/widgets/add_expense_sheet.dart';

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  void _showAddExpenseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => const AddExpenseSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}