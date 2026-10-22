import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/utils/supabase_gVariable.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
  await Future.delayed(Duration(seconds: 5));

  if (!mounted) return;

  final session = supabase.auth.currentSession;
  if (session != null) {
  Navigator.pushReplacementNamed(context, '/home');
} else {
  Navigator.pushReplacementNamed(context, '/login');
}
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6366F1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ), // BoxShadow
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Color(0xFF6366F1),
               ), // BoxDecoration
            ),
            const SizedBox(height: 24),
            const Text(
              'Expense Tracker',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your expenses effortlessly',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),// Container
          ],
        ), // Column
      ), // Center
    );
  }
}