import 'package:flutter/material.dart';
import 'package:tiket/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiketGO SignIn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2E3F7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gambar Header
              Image.asset(
                'assets/tiketgo.png',
                width: 200,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              // Logo dan Text

              const SizedBox(height: 8),
              const Text(
                'Welcome to TiketGO',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 0, 103, 177),
                ),
              ),
              const SizedBox(height: 16),
              // Input Username
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'E-mail',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              // Input Password
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              // Teks Daftar
              const Text(
                'Belum punya akun?',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00BFFF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tombol Masuk
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFFF),
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(fontFamily: 'sans-serif-medium'),
                  ),
                  onPressed: () {
                    // Tambah login
                  },
                  child: const Text(
                    'Masuk',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
