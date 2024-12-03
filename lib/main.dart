import 'package:flutter/material.dart';
import 'package:tiket/user/kereta/konfirmasi.dart';
import 'package:tiket/user/pesawat/cari.dart';
<<<<<<< HEAD
=======
import 'package:tiket/user/kapal/bayar.dart';
>>>>>>> 5d05ff0ad39c0b8486e7479f91eb9eac134795ef
//import 'package:tiket/user/pesawat/inputdata.dart';
import 'package:tiket/user/kapal/inputdata.dart';
import 'package:tiket/admin/admin.dart';
import 'package:tiket/user/kapal/cari.dart';
import 'package:tiket/user/user.dart';
import 'package:tiket/user/pesawat/checkin.dart';

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
<<<<<<< HEAD
          PasswordInputPage(), //LoginScreen(), //datakereta(), // Menetapkan LoginScreen sebagai halaman awa
=======
          const LoginScreen(), //LoginScreen(), //datakereta(), // Menetapkan LoginScreen sebagai halaman awa
>>>>>>> 5d05ff0ad39c0b8486e7479f91eb9eac134795ef
      debugShowCheckedModeBanner: false,
    );
  }
}
