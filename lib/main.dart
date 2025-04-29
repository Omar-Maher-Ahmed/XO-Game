import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XO Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        useMaterial3: true,
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
