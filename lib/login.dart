import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:tiket/user/user.dart';
import 'package:tiket/util/config/config.dart';
import 'package:tiket/register.dart'; // Ganti dengan path yang sesuai jika perlu
import 'package:http/http.dart' as http;
import 'dart:convert';
=======
import 'package:tiket/register.dart';
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0

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

<<<<<<< HEAD
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers untuk TextField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk melakukan login
  Future<void> _loginUser() async {
    // Validasi input
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      return;
    }

    // URL untuk API PHP login
    final url = Uri.http(AppConfig.API_HOST,
        '/tiket_go/login.php'); // Ganti dengan URL server kamu

    // Kirim data ke API menggunakan HTTP POST
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'Email': _emailController.text,
        'Password': _passwordController.text,
      }),
    );

    // Cek apakah login berhasil
    final responseBody = json.decode(response.body);
    if (response.statusCode == 200 && responseBody['success'] == true) {
      // Jika berhasil login, pindah ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const HomeScreen()), // Ganti dengan halaman utama aplikasi kamu
      );
    } else {
      // Jika gagal login, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody['message'])),
      );
    }
  }

  @override
=======
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
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
<<<<<<< HEAD
=======
              // Logo dan Text

              const SizedBox(height: 8),
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
              const Text(
                'Welcome to TiketGO',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 0, 103, 177),
                ),
              ),
              const SizedBox(height: 16),
<<<<<<< HEAD
              // Input Email
=======
              // Input Username
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'E-mail',
<<<<<<< HEAD
                  style: TextStyle(fontSize: 14, color: Colors.black),
=======
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
                ),
              ),
              const SizedBox(height: 4),
              TextField(
<<<<<<< HEAD
                controller: _emailController,
=======
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
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
<<<<<<< HEAD
                  style: TextStyle(fontSize: 14, color: Colors.black),
=======
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
                ),
              ),
              const SizedBox(height: 4),
              TextField(
<<<<<<< HEAD
                controller: _passwordController,
=======
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
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
<<<<<<< HEAD
                style: TextStyle(fontSize: 12, color: Colors.black),
=======
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
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
<<<<<<< HEAD
                  onPressed: _loginUser,
=======
                  onPressed: () {
                    // Tambah login
                  },
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
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
<<<<<<< HEAD

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Selamat datang di halaman utama!')),
    );
  }
}
=======
>>>>>>> dbc4b8a1ba88bdd1257d582173887322536163c0
