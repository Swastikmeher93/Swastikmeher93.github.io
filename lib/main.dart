import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screen/home_view.dart';

void main() {
  runApp(
    // ProviderScope is required at the root — it initialises the Riverpod
    // container that stores all provider state.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swastik — Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4AABDB),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeView(),
    );
  }
}
