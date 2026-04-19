import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SpiceUpApp());
}

class SpiceUpApp extends StatelessWidget {
  const SpiceUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spice Up UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.backgroundBottom,
      ),
      home: const LoginScreen(), // Memanggil halaman Login
    );
  }
}