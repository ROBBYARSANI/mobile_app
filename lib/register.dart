import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tiket/util/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:tiket/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiketGO SignUP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controller untuk form input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Fungsi untuk mengirim data pendaftaran ke server
  Future<void> _registerUser() async {
    // Mengecek apakah password dan konfirmasi password cocok
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password dan Konfirmasi Password tidak cocok")),
      );
      return;
    }

    // Validasi NIK (pastikan hanya angka dan sesuai format)
    if (_nikController.text.isEmpty ||
        !_nikController.text.contains(RegExp(r'^\d+$'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NIK harus berupa angka")),
      );
      return;
    }

    // Mengirimkan data pendaftaran ke server PHP menggunakan HTTP POST
    final url = Uri.http(AppConfig.API_HOST, '/tiket_go/register.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'Email': _emailController.text,
        'nik': _nikController.text,
        'Password': _passwordController.text,
      }),
    );

    // Mengecek respon dari server
    final responseBody = json.decode(response.body);
    if (response.statusCode == 200 && responseBody['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody['message'])),
      );
    }
  }

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
              Image.asset(
                'assets/tiketgo.png',
                width: 200,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat Datang di TiketGo',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 0, 103, 177),
                ),
              ),
              const SizedBox(height: 16),
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
                controller: _emailController,
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'NIK',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _nikController,
                decoration: InputDecoration(
                  hintText: 'Masukkan NIK',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
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
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Masukkan kata sandi baru',
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
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Konfirmasi Password',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Tulis ulang kata sandi',
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFFF),
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(fontFamily: 'sans-serif-medium'),
                  ),
                  onPressed: _registerUser,
                  child: const Text(
                    'Daftar',
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
