import 'dart:convert';
import 'package:tiket/util/config/config.dart';
import 'package:tiket/user/pesawat/daftartiket.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class kapalpage extends StatefulWidget {
  const kapalpage({super.key});

  @override
  State<kapalpage> createState() => _kapalpagestate();
}

class _kapalpagestate extends State<kapalpage> {
  int jumlahDewasa = 0;
  DateTime? tanggalBerangkat;
  String? keberangkatan;
  String? tujuan;
  String? tipeKelas;

  // Fungsi untuk memilih tanggal
  Future<void> pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != tanggalBerangkat) {
      setState(() {
        tanggalBerangkat = picked;
      });
    }
  }

  // Fungsi untuk mencari tiket dan mengirim data ke API
  Future<void> cariTiket() async {
    if (keberangkatan == null ||
        tujuan == null ||
        tipeKelas == null ||
        tanggalBerangkat == null ||
        jumlahDewasa == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    final Uri url =
        Uri.http(AppConfig.API_HOST, '/tiket_go/pesawat/cari_ps.php');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "keberangkatan": keberangkatan,
          "tujuan": tujuan,
          "jumlah_tiket": jumlahDewasa,
          "tipe_kelas": tipeKelas,
          "tanggal":
              "${tanggalBerangkat!.year}-${tanggalBerangkat!.month.toString().padLeft(2, '0')}-${tanggalBerangkat!.day.toString().padLeft(2, '0')}",
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Jika sukses, arahkan ke halaman daftar tiket
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DaftarTiketScreen(tickets: data['tickets']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal mencari tiket')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
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
          'Cari pesawat',
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
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Ingin Pergi Kemana?",
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
                          // Keberangkatan dan Tujuan
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Keberangkatan",
                                        style: TextStyle(fontSize: 14)),
                                    DropdownButtonFormField<String>(
                                      items: [
                                        "Surabaya",
                                        "Bali",
                                        "Jakarta",
                                        "Medan",
                                        "Makassar",
                                        "Yogyakarta",
                                        "Bandung",
                                        "Singapore",
                                        "Kuala Lumpur",
                                        "Sydney"
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          keberangkatan = value;
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
                                    DropdownButtonFormField<String>(
                                      items: [
                                        "Surabaya",
                                        "Bali",
                                        "Jakarta",
                                        "Medan",
                                        "Makassar",
                                        "Yogyakarta",
                                        "Bandung",
                                        "Singapore",
                                        "Kuala Lumpur",
                                        "Sydney"
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          tujuan = value;
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

                          // Jumlah Tiket Dewasa
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Jumlah Tiket",
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

                          // Kelas
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
                                  ? "${tanggalBerangkat!.year}-${tanggalBerangkat!.month.toString().padLeft(2, '0')}-${tanggalBerangkat!.day.toString().padLeft(2, '0')}"
                                  : "Masukan tanggal",
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Cari
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
                    onPressed: cariTiket,
                    child: const Text(
                      "Cari",
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