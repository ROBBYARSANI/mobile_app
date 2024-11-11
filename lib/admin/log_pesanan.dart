import 'package:flutter/material.dart';

class LogPesananPage extends StatelessWidget {
  const LogPesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Pesanan")),
      body: const Center(child: Text("Tabel pesanan")),
    );
  }
}
