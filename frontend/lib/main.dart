import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/auth/view/pages/signin_page.dart';
import 'package:frontend/features/auth/view/pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: const SignUpPage(),
    );
  }
}
