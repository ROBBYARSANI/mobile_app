import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiket/login.dart';
import 'package:tiket/user/kapal/cari.dart';
import 'package:tiket/user/kereta/cari.dart';
import 'package:tiket/user/pesawat/cari.dart';
import 'package:tiket/user/riwayat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userEmail = "User"; // Nilai default sementara
  int _selectedIndex = 0; // Untuk mengelola navigasi

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  // Fungsi untuk mengambil email dari SharedPreferences
  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('userEmail') ?? "User";
    });
  }

  // Fungsi untuk berpindah halaman berdasarkan menu yang dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan tampilan berdasarkan menu yang dipilih
    final List<Widget> _pages = [
      _buildHomePage(context),
      const LogPesananPage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }

  // Tampilan halaman Home
  Widget _buildHomePage(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_home_wave.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      // Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Selamat Datang",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 78, 119, 208),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  _userEmail,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 93, 141, 254),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/tiketgo.png'),
                              radius: 25,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Banner Image
                Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Image.asset(
                    'assets/gambar.jpg',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pilih Transportasi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // List Transport
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    transportCard(
                      context,
                      'Pesawat',
                      'Transportasi Udara',
                      'assets/ic_plane.png',
                      const pesawatpage(),
                    ),
                    transportCard(
                      context,
                      'Kapal Laut',
                      'Transportasi Laut',
                      'assets/ic_ship.png',
                      const kapalpage(),
                    ),
                    transportCard(
                      context,
                      'Kereta',
                      'Transportasi Darat',
                      'assets/ic_train.png',
                      const keretapage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
                  color: Colors.white,
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
