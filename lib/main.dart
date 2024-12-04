import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiket/user/kapal/bayar.dart';
import 'package:tiket/user/kereta/konfirmasi.dart';
import 'package:tiket/user/pesawat/cari.dart';
//import 'package:tiket/user/pesawat/inputdata.dart';
import 'package:tiket/user/kapal/inputdata.dart';
import 'package:tiket/admin/admin.dart';
import 'package:tiket/user/kapal/cari.dart';
import 'package:tiket/user/user.dart';
//import 'package:tiket/user/pesawat/checkin.dart';
import 'package:tiket/user/kereta/checkin.dart';

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
          datakapal(), //LoginScreen(), //datakereta(), // Menetapkan LoginScreen sebagai halaman awa
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Utama'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman pilih kursi
            Get.to(() => PilihKursiView());
          },
          child: Text('Pilih Kursi'),
        ),
      ),
    );
  }
}
