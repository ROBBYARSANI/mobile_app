import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiket/util/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tiket/user/pesawat/daftartiket.dart';

class pesawatpage extends StatefulWidget {
  const pesawatpage({super.key});

  @override
  State<pesawatpage> createState() => _PesawatPageState();
}

class _PesawatPageState extends State<pesawatpage> {
  // Controller untuk mengambil input dari TextField
  final namaPenumpangController = TextEditingController();
  final nomorTeleponController = TextEditingController();

  DateTime? tanggalBerangkat; // Variabel untuk tanggal berangkat
  int? keberangkatanId; // Variabel untuk keberangkatan
  int? tujuanId; // Variabel untuk tujuan
  String? tipeKelas; // Variabel untuk tipe kelas
  int jumlahAnak = 0; // Variabel untuk jumlah anak
  int jumlahDewasa = 0; // Variabel untuk jumlah dewasa

  // Fungsi untuk memilih tanggal
  Future<void> pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != tanggalBerangkat)
      setState(() {
        tanggalBerangkat = picked;
      });
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
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
        Uri.http(AppConfig.API_HOST, '/tiket_go/pesawat/input_data.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId, // Ganti dengan user_id yang sesuai
        "nama_penumpang": namaPenumpangController.text, // Ambil dari TextField
        "nomor_telepon": nomorTeleponController.text, // Ambil dari TextField
        "tanggal_berangkat": tanggalBerangkat?.toIso8601String().split("T")[0],
        "keberangkatan_id":
            keberangkatanId, // Ambil dari dropdown keberangkatan
        "tujuan_id": tujuanId, // Ambil dari dropdown tujuan
        "tipe_kelas": tipeKelas, // Ambil dari dropdown tipe kelas
        "jumlah_anak": jumlahAnak,
        "jumlah_dewasa": jumlahDewasa,
      }),
    );

    if (response.statusCode == 200) {
      // Jika berhasil, navigasi ke halaman tiket atau tampilkan pesan sukses
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Jika gagal, tampilkan pesan error
      print("Error: ${response.body}");
    }
  }

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

                          // Keberangkatan dan Tujuan
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Keberangkatan",
                                        style: TextStyle(fontSize: 14)),
                                    DropdownButtonFormField<int>(
                                      value: keberangkatanId,
                                      items: [
                                        DropdownMenuItem<int>(
                                            value: 1,
                                            child: Text(
                                                "Jakarta")), // ID 1 untuk Jakarta
                                        DropdownMenuItem<int>(
                                            value: 2,
                                            child: Text(
                                                "Bandung")), // ID 2 untuk Bandung
                                      ],
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          keberangkatanId = newValue;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Icon(Icons.compare_arrows,
                                  color: Colors.blue),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Tujuan",
                                        style: TextStyle(fontSize: 14)),
                                    DropdownButtonFormField<int>(
                                      value: tujuanId,
                                      items: [
                                        DropdownMenuItem<int>(
                                            value: 1,
                                            child: Text(
                                                "Jakarta")), // ID 1 untuk Jakarta
                                        DropdownMenuItem<int>(
                                            value: 2,
                                            child: Text(
                                                "Surabaya")), // ID 2 untuk Bandung
                                      ],
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          tujuanId = newValue;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

                          // Tipe / Kelas
                          const Text("Tipe / Kelas",
                              style: TextStyle(fontSize: 14)),
                          DropdownButtonFormField<String>(
                            items: ["Ekonomi", "Bisnis", "Eksekutif"]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                tipeKelas = value;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tanggal Berangkat
                          const Text("Tanggal Berangkat",
                              style: TextStyle(fontSize: 14)),
                          TextField(
                            onTap: () async {
                              await pilihTanggal(context);
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: tanggalBerangkat != null
                                  ? "${tanggalBerangkat!.day}/${tanggalBerangkat!.month}/${tanggalBerangkat!.year}"
                                  : "Masukan tanggal",
                              border: const OutlineInputBorder(),
                            ),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Button Checkout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    onPressed: () {
                      pesanTiket(); // Memanggil fungsi pesanTiket saat tombol diklik
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
