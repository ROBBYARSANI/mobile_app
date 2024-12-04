import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiket/user/pesawat/bayar.dart';
import 'package:tiket/user/pesawat/checkin.dart';
import 'package:tiket/util/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//import 'package:tiket/user/pesawat/daftartiket.dart';

class pesawatpage extends StatefulWidget {
  const pesawatpage({super.key});

  @override
  State<pesawatpage> createState() => _PesawatPageState();
}

class _PesawatPageState extends State<pesawatpage> {
  // Controller untuk mengambil input dari TextField
  final namaPenumpangController = TextEditingController();
  final nomorTeleponController = TextEditingController();
  int jumlahAnak = 0; // Variabel untuk jumlah anak
  int jumlahDewasa = 0; // Variabel untuk jumlah dewasa

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<int?> gettransportId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id_transport');
  }

  // Fungsi untuk mengirim data ke API
  Future<void> pesanTiket() async {
    final userId = await getUserId(); // Ambil user_id yang telah disimpan
    if (userId == null) {
      // Tangani jika user_id tidak ditemukan (misalnya, user belum login)
      print("User belum login");
      return;
    }

    final url =
        Uri.http(AppConfig.API_HOST, '/tiket_go/pesawat/input_data_ps.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId, // Ganti dengan user_id yang sesuai
        "nama_penumpang": namaPenumpangController.text, // Ambil dari TextField
        "nomor_telepon": nomorTeleponController.text, // Ambil dari TextField
        "jumlah_anak": jumlahAnak,
        "jumlah_dewasa": jumlahDewasa,
      }),
    );

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      try {
        final data = jsonDecode(response.body);
        final idPemesanan = data['id_pemesanan'];
        if (idPemesanan == null) {
          print("Error: id_pemesanan tidak ditemukan");
          return;
        }
        print("Data berhasil disimpan: $data");
        await kirimKeTransaksi(idPemesanan);
      } catch (e) {
        print("Kesalahan parsing JSON: ${response.body}");
      }
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
    }
  }

  Future<void> kirimKeTransaksi(int idPemesanan) async {
    final tUser = await gettransportId();
    if (tUser == null) {
      // Tangani jika user_id tidak ditemukan (misalnya, user belum login)
      print("Sepertinya masih ada masalah");
      return;
    }

    final urlTransaksi =
        Uri.http(AppConfig.API_HOST, '/tiket_go/pesawat/transaksi_ps.php');
    final response = await http.post(
      urlTransaksi,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_pemesanan": idPemesanan,
        "id_transport": tUser,
      }),
    );

    if (response.statusCode == 200) {
      print("Transaksi berhasil disimpan");

      if (pilih) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_pemesanan', idPemesanan); // Simpan id_pemesanan

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PilihKursiView() /*PaymentPage()*/),
        );
      } else {
        // Navigasi ke halaman Payment
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentPage()),
        );
      }
    } else {
      print("Error saat menyimpan transaksi: ${response.body}");
    }
  }

  // Tambahkan state baru untuk menyimpan status switch
  bool pilih = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2E3F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Pesan Tiket',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(10),
                      child: const Row(
                        children: [
                          Icon(Icons.co_present, color: Colors.white),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Mohon isi data dibawah ini sesuai dengan KTP Anda",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nama Penumpang",
                              style: TextStyle(fontSize: 14)),
                          TextField(
                            controller:
                                namaPenumpangController, // Ambil dari controller
                            decoration: const InputDecoration(
                              hintText: "Masukan nama lengkap",
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Jumlah Anak-anak
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Anak-anak (16+ tahun)",
                                  style: TextStyle(fontSize: 14)),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        if (jumlahAnak > 0) jumlahAnak--;
                                      });
                                    },
                                  ),
                                  Text("$jumlahAnak",
                                      style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        if (jumlahAnak < 5) jumlahAnak++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Jumlah Dewasa
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Dewasa",
                                  style: TextStyle(fontSize: 14)),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        if (jumlahDewasa > 0) jumlahDewasa--;
                                      });
                                    },
                                  ),
                                  Text("$jumlahDewasa",
                                      style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        if (jumlahDewasa < 5) jumlahDewasa++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Nomor Telp / HP
                          const Text("Nomor Telp / HP",
                              style: TextStyle(fontSize: 14)),
                          TextField(
                            controller:
                                nomorTeleponController, // Ambil dari controller
                            decoration: const InputDecoration(
                              hintText: "Masukan nomor telepon",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(
                                16.0), // Margin seragam 16 piksel di semua sisi
                            child: Text(
                              'E-tiket akan dikirim ke Example@gmail.com',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tambahkan Switch di sini
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pilih kursi sekarang",
                      style: TextStyle(fontSize: 14),
                    ),
                    Switch(
                      value: pilih,
                      onChanged: (bool value) {
                        setState(() {
                          pilih = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // Button Checkout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pilih ? Colors.blue : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    onPressed: () {
                      pesanTiket();
                    },
                    child: const Text(
                      "Pesan",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
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
