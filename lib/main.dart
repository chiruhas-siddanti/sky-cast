import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const SkyCastApp());

/// Root widget of the SkyCast weather application.
class SkyCastApp extends StatelessWidget {
  const SkyCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyCast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
