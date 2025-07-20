import 'package:flutter/material.dart';
import 'constants/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SprintScopeApp());
}

class SprintScopeApp extends StatelessWidget {
  const SprintScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SprintScope',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
