import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan jalur ini sesuai dengan lokasi file LoginScreen Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiketGO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Menetapkan LoginScreen sebagai halaman awal
      debugShowCheckedModeBanner: false,
    );
  }
}
