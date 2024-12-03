import 'package:flutter/material.dart';
import 'login.dart';

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
      //infokan jika dibypass
      home:
          const LoginScreen(), //LoginScreen(), //datakereta(), // Menetapkan LoginScreen sebagai halaman awa
      debugShowCheckedModeBanner: false,
    );
  }
}
