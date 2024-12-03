import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:tiket/util/config/config.dart';

class LogPesananPage extends StatefulWidget {
  const LogPesananPage({Key? key}) : super(key: key);

  @override
  _LogPesananPageState createState() => _LogPesananPageState();
}

class _LogPesananPageState extends State<LogPesananPage> {
  List<dynamic> _pesananList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogPesanan();
  }

  Future<void> _fetchLogPesanan() async {
    final url = Uri.http(AppConfig.API_HOST, '/tiket_go/admin/log.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status']) {
          setState(() {
            _pesananList = data['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengambil data.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<void> _deletePesanan(String idTransaksi) async {
    final url = Uri.http(AppConfig.API_HOST, '/tiket_go/admin/hapus_log.php',
        {'id_transaksi': idTransaksi});

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['status']) {
        // Jika berhasil, hapus data dari list dan beri notifikasi
        setState(() {
          _pesananList
              .removeWhere((item) => item['id_transaksi'] == idTransaksi);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dihapus.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: ${data['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat menghapus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Pesanan')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pesananList.isEmpty
              ? const Center(child: Text('Tidak ada pesanan.'))
              : ListView.builder(
                  itemCount: _pesananList.length,
                  itemBuilder: (context, index) {
                    final pesanan = _pesananList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: Icon(
                          pesanan['jenis_transport'] == 'Kapal'
                              ? Icons.directions_boat
                              : pesanan['jenis_transport'] == 'Kereta'
                                  ? Icons.train
                                  : Icons.airplanemode_active,
                        ),
                        title: Text(
                            '${pesanan['nama_transport']} (${pesanan['jenis_transport']})'),
                        subtitle: Text(
                          'Tujuan: ${pesanan['tujuan']}\n'
                          'Tanggal: ${pesanan['waktu_keberangkatan'] != null ? DateFormat('yyyy MMM dd').format(DateTime.parse(pesanan['waktu_keberangkatan'])) : "Tanggal tidak tersedia"}\n'
                          'Harga: Rp${pesanan['total_harga']}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Konfirmasi sebelum menghapus
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Apakah Anda yakin ingin menghapus data ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Tutup dialog
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Tutup dialog
                                      _deletePesanan(pesanan['id_transaksi']);
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
