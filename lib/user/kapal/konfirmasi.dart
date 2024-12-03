import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:tiket/util/config/config.dart';

class PasswordInputPage extends StatefulWidget {
  @override
  _PasswordInputPageState createState() => _PasswordInputPageState();
}

class _PasswordInputPageState extends State<PasswordInputPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });
  }

  Future<void> _validatePassword() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan ID pengguna')),
      );
      return;
    }

    // Menggunakan Uri.http
    final url = Uri.http(AppConfig.API_HOST,
        'tiket_go/kapal/konfirmasi_kp.php'); //http://localhost/tiket_go/kapal/konfirmasi_kp.php
    final response = await http.post(
      url,
      body: jsonEncode({
        'user_id': userId,
        'password': _passwordController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (data['status']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
      Navigator.pop(context); // Contoh: kembali ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Masukkan Password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Gunakan password Anda untuk konfirmasi pembayaran',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 40),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validatePassword,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Bayar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
