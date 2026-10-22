import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_expense_tracker/providers/expense_provider.dart';
import 'package:personal_expense_tracker/screens/home_screen.dart';
import 'package:personal_expense_tracker/screens/login_screen.dart';
import 'package:personal_expense_tracker/screens/signup_screen.dart';
import 'package:personal_expense_tracker/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpkZmJnamlnaHZpZnJ3c3Rta2pjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4OTk0MTcxNCwiZXhwIjoyMTA1NTE3NzE0fQ.iuBLywbeEWWNXJmMq17iahNT2fNc-uTioLJ1uIvbzhY',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpkZmJnamlnaHZpZnJ3c3Rta2pjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk5NDE3MTQsImV4cCI6MjEwNTUxNzcxNH0.O7XEnDcbgvxYiziAuUnInVVeHDzj0Rolo8C7Ld-5lG0',
  );

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF6366F1),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ), // OutlineInputBorder
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ), // OutlineInputBorder
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(0xFF6366F1),
              width: 2,
            ), // BorderSide
          ), // OutlineInputBorder
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.redAccent,
              width: 2,
            ), // BorderSide
          ), // OutlineInputBorder
        ), // InputDecorationTheme
      ), // ThemeData
       home: SplashScreen(),
       routes: {
        '/login':  (context) => const LoginScreen(),
        '/signup':  (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        
       },
      ),
    );
  }
}