import 'package:flutter/material.dart';
import 'package:sensei/features/auth/screens/login_screen.dart';
import 'package:sensei/theme/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensei',
      debugShowCheckedModeBanner: false,
      theme: Pallete.darkModeAppTheme,
      home: const LoginScrren(),
    );
  }
}
