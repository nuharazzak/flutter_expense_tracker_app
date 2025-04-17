import 'package:flutter/material.dart';
import 'package:wallpaper_app/wallpaper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 7, 9, 140)),
      ),
      home: const Wallpaper(),
    );
  }
}
