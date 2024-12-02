import 'package:flutter/material.dart';
import 'package:tiket/user/pesawat/cari.dart';
import 'package:tiket/user/pesawat/bayar.dart';
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
          const HomeScreen(), //LoginScreen(), //datakereta(), // Menetapkan LoginScreen sebagai halaman awa
=======
          const LoginScreen(), //LoginScreen(), //datakereta(), // Menetapkan LoginScreen sebagai halaman awa
>>>>>>> be6c40d00d798debddd9f8767298ecac1c01e976
      debugShowCheckedModeBanner: false,
    );
  }
}
