import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiket/util/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiket/user/kapal/konfirmasi.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = 'GOPAY';
  late String userName;
  late String userNik;
  late int jumlahDewasa;
  late double hargaJual;
  late String kursi;

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPaymentDetails();
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  // Fungsi untuk mengambil data pembayaran dari API PHP
  Future<void> _fetchPaymentDetails() async {
    // Ambil user_id dari SharedPreferences
    final userId = await getUserId();

    if (userId == null) {
      // Jika user_id tidak ditemukan, tampilkan pesan error
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }

    final uri = Uri.http(AppConfig.API_HOST,
        '/tiket_go/pesawat/bayar_ps.php'); // Sesuaikan dengan endpoint Anda

    // Kirim user_id sebagai parameter dalam body
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId}),
    );

    final responseData = json.decode(response.body);

    print('Response status: ${response.statusCode}');
    print(
        'Response body: ${response.body}'); // Debugging untuk melihat response

    try {
      if (responseData['status'] == true) {
        setState(() {
          userName = responseData['data']['nama_penumpang'];
          userNik = responseData['data']['nik'].toString();
          jumlahDewasa = responseData['data']['jumlah_dewasa'];
          hargaJual = double.parse(responseData['data']['harga_jual']);
          kursi = responseData['data']['n_kursi'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  // Fungsi untuk memilih metode pembayaran
  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("GOPAY"),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = "GOPAY";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("PayPall"),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = "PayPall";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Dana"),
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = "Dana";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigasi kembali
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError
                ? const Center(
                    child: Text('Terjadi kesalahan saat mengambil data'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Data Pengguna
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Nama Pemesan",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(userName,
                                style: const TextStyle(fontSize: 15)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Text("NIK",
                                    style: TextStyle(fontSize: 15)),
                                const SizedBox(width: 16),
                                Text(userNik,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text("Kursi", style: TextStyle(fontSize: 15)),
                            const SizedBox(height: 8),
                            Text(kursi, style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Rincian Harga
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Rincian Harga",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            const Text("Harga yang harus anda bayar"),
                            Text("Taksaka Tambahan (Dewasa) x$jumlahDewasa",
                                style: const TextStyle(color: Colors.grey)),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("+ Asuransi Perjalanan"),
                                Text("RP 34.000"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("RP ${hargaJual * jumlahDewasa + 34000}",
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // metode pembayaran
                      const Text("Metode Pembayaran",
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _showPaymentOptions,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedPaymentMethod,
                                  style: const TextStyle(fontSize: 16)),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Logika bayar
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasswordInputPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: const Text("Bayar"),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
