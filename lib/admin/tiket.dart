import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tiket/util/config/config.dart';
import 'package:http/http.dart' as http;

class TicketsPage extends StatefulWidget {
  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<dynamic> tickets = [];
  bool isLoading = true;

  String convertToTime(String? timeStr) {
    int minutes = 0;
    if (timeStr != null && timeStr.isNotEmpty) {
      minutes = int.tryParse(timeStr) ?? 0; // Default ke 0 jika parsing gagal
    }

    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
  }

  String convertDuration(String? durationStr) {
    int durationInMinutes = 0;
    if (durationStr != null && durationStr.isNotEmpty) {
      durationInMinutes =
          int.tryParse(durationStr) ?? 0; // Default ke 0 jika parsing gagal
    }

    int hours = durationInMinutes ~/ 60;
    int minutes = durationInMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final Uri url =
        Uri.http(AppConfig.API_HOST, '/tiket_go/admin/daftartiket.php');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tickets = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gagal Memuat Tiket'),
            content: Text('Status Kode: ${response.statusCode}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Terjadi Kesalahan'),
          content: Text('Error: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> deleteTicket(int ticketId, String transportType) async {
    String table;

    if (transportType == 'pesawat') {
      table = 'transport_ps';
    } else if (transportType == 'kapal') {
      table = 'transport_kp';
    } else if (transportType == 'kereta') {
      table = 'transport_kr';
    } else {
      throw Exception('Jenis transportasi tidak valid');
    }

    final Uri url = Uri.http(
        AppConfig.API_HOST,
        '/tiket_go/admin/hapustiket.php',
        {'table': table, 'id': ticketId.toString()});

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        fetchTickets();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gagal Menghapus Tiket'),
            content: Text('Status Kode: ${response.statusCode}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Terjadi Kesalahan'),
          content: Text('Error: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tiket'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              ticket['logo'] ?? '', // Logo Maskapai
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              ticket['nama_transport'] ?? 'Nama Transportasi',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Keberangkatan",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  ticket['keberangkatan'] ?? 'Tidak Diketahui',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tujuan",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  ticket['tujuan'] ?? 'Tidak Diketahui',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tanggal Berangkat",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  ticket['tanggal_k'] ?? 'Tidak Diketahui',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tanggal Sampai",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  ticket['tanggal_t'] ?? 'Tidak Diketahui',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Waktu Takeoff",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                                Text(
                                  convertToTime(ticket['waktu_k']),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Waktu Landing",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                                Text(
                                  convertToTime(ticket['waktu_t']),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              "Lama Penerbangan",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              convertDuration(ticket['l_waktu'] ?? '0'),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            deleteTicket(int.parse(ticket['id'].toString()),
                                ticket['jenis_transportasi'] ?? 'pesawat');
                          },
                          child: const Text('Hapus Tiket'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
