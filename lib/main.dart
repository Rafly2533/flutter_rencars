import 'package:flutter/material.dart';
import 'package:flutter_rencars/screens/login.dart';
// import 'login.dart'; // tetap boleh ada kalau dipakai di landing

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Rental Mobil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LandingPage(), // 🔥 ganti ke LandingPage
      debugShowCheckedModeBanner: false,
    );
  }
}