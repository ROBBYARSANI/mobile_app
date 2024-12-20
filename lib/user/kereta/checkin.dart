import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiket/user/kereta/bayar.dart';
import 'package:tiket/util/config/config.dart';

class PilihKursiView extends StatefulWidget {
  @override
  _PilihKursiViewState createState() => _PilihKursiViewState();
}

class _PilihKursiViewState extends State<PilihKursiView> {
  List<Map<String, dynamic>> gerbong = [];
  bool isLoading = true;

  String namaKereta = ""; // Nama transportasi
  String kelasKereta = ""; // Kelas transportasi
  int idPemesanan = 0;

  @override
  void initState() {
    super.initState();
    _loadTransportData();
  }

  // Mengambil data nama transportasi dan kelas dari SharedPreferences
  Future<void> _loadTransportData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaKereta =
          prefs.getString('nama_transport') ?? "Transportasi Tidak Diketahui";
      kelasKereta = prefs.getString('kelas') ?? "Kelas Tidak Diketahui";
      idPemesanan = prefs.getInt('id_pemesanan') ?? 0;
    });

    // Tentukan gerbong berdasarkan kelas
    String gerbongName = "";
    if (kelasKereta == "Ekonomi") {
      gerbongName = "A";
    } else if (kelasKereta == "Bisnis") {
      gerbongName = "B";
    } else if (kelasKereta == "Eksekutif") {
      gerbongName = "C";
    }

    fetchKursi(gerbongName);
  }

  // Mengambil data kursi dari API
  Future<void> fetchKursi(String gerbongName) async {
    final Uri url = Uri.http(AppConfig.API_HOST,
        '/tiket_go/kereta/get_kursi.php', {'gerbong': gerbongName});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        setState(() {
          gerbong =
              List<Map<String, dynamic>>.from(data['data'].map((kursi) => {
                    "id": kursi['id'],
                    "n_kursi": kursi['n_kursi'],
                    "status": kursi['status'] == 1 ? "available" : "filled",
                  }));
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengambil data kursi')));
    }
  }

  // Memperbarui status kursi
  Future<void> updateKursi(int id, String newStatus, int idPemesanan) async {
    final Uri url =
        Uri.http(AppConfig.API_HOST, '/tiket_go/kereta/update_kursi.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_kursi": id,
        "status": newStatus == 'available' ? 1 : 0,
        "id_pemesanan": idPemesanan,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Status kursi berhasil diperbarui')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui status kursi')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim permintaan update')));
      print(id);
      print(newStatus);
      print(idPemesanan);
    }
  }

  // Menangani pemilihan kursi
  void selectKursi(int index) async {
    var kursi = gerbong[index];
    String newStatus =
        kursi['status'] == 'available' ? 'selected' : 'available';

    await updateKursi(kursi['id'], newStatus, idPemesanan);

    setState(() {
      kursi['status'] = newStatus; // Update status kursi di aplikasi
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Kursi',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaKereta,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Kelas: $kelasKereta",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: gerbong.length,
                    itemBuilder: (context, index) {
                      var kursi = gerbong[index];
                      return GestureDetector(
                        onTap: () => selectKursi(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kursi['status'] == 'available'
                                ? Colors.green
                                : kursi['status'] == 'selected'
                                    ? Colors.blue
                                    : Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(kursi['n_kursi'])),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/IsiDataPage');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Warna biru
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(
                        "Pilih",
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
    );
  }
}
