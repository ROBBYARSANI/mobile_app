import 'package:flutter/material.dart';
import 'jadwal.dart';
import 'tiket.dart';
import 'log_pesanan.dart';

//pw admin12345
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AdminScreen(),
      theme: ThemeData(primaryColor: Colors.blue),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_home_wave.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            top: 260,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/putih.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat Datang",
                            style: TextStyle(
                              color: Color.fromARGB(255, 6, 31, 86),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Admin",
                            style: TextStyle(
                              color: Color.fromARGB(255, 6, 31, 86),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/ic_profile.png'),
                        radius: 25,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Kelola Data",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      transportCard(
                        context,
                        'UPDATE JADWAL',
                        'UPDATE JADWAL TIKET',
                        'assets/ic_jadwal.png',
                        const JadwalPage(),
                      ),
                      transportCard(
                        context,
                        'LOG PESANAN',
                        'CEK LOG PESANAN',
                        'assets/ic_pesanan.png',
                        const LogPesananPage(),
                      ),
                      transportCard(
                        context,
                        'DAFTAR TIKET',
                        'CEK DAFTAR TIKET',
                        'assets/ic_tiket.png',
                        const TiketPage(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget transportCard(BuildContext context, String title, String subtitle,
      String iconPath, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_rounded_top.png'),
              fit: BoxFit.cover,
            ),
          ),
          height: 150,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(
                  iconPath,
                  width: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
