import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiket/user/kapal/inputdata.dart';

String _getSingkatan(String kota) {
  final Map<String, String> singkatanKota = {
    'Surabaya': 'SBY',
    'Jakarta': 'JKT',
    'Bandung': 'BDG',
    'Yogyakarta': 'YOG',
  };
  return singkatanKota[kota] ?? kota;
}

String formatJam(int waktu) {
  String waktuStr = waktu
      .toString()
      .padLeft(4, '0'); // Pastikan format 4 digit (contoh: 0800)
  String jam = waktuStr.substring(0, 2); // Ambil 2 digit pertama untuk jam
  String menit = waktuStr.substring(2); // Ambil 2 digit terakhir untuk menit
  return "$jam:$menit"; // Gabungkan dengan format "HH:mm"
}

String formatDurasi(int durasi) {
  double durasiJam = durasi / 100; // Contoh: 120 menjadi 1.2
  return '${durasiJam.toStringAsFixed(1)} H';
}

String formatHarga(double harga) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID', // Gunakan format Indonesia
    symbol: 'Rp ', // Simbol mata uang
    decimalDigits: 2, // Jumlah angka di belakang koma
  );
  return formatter.format(harga); // Format harga sesuai pengaturan
}

class DaftarTiketScreen extends StatefulWidget {
  final List<dynamic> tickets;

  const DaftarTiketScreen({Key? key, required this.tickets}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DaftarTiketScreenState createState() => _DaftarTiketScreenState();
}

class _DaftarTiketScreenState extends State<DaftarTiketScreen> {
  // Variabel untuk menyimpan status filter dan sort
  List<dynamic> filteredTickets = [];
  bool sortByMorningToNight = false;
  bool sortByNightToMorning = false;
  bool sortByLowToHigh = false;
  bool sortByHighToLow = false;

  @override
  void initState() {
    super.initState();
    // Setel filteredTickets ke tiket awal
    filteredTickets = widget.tickets;
  }

  // Fungsi untuk menerapkan filter berdasarkan maskapai

  // Fungsi untuk menerapkan sort berdasarkan harga atau waktu
  void _applySort() {
    setState(() {
      if (!sortByNightToMorning &&
          !sortByMorningToNight &&
          !sortByHighToLow &&
          !sortByLowToHigh) {
        filteredTickets.sort((a, b) => a['id'].compareTo(b['id']));
      } else {
        if (sortByMorningToNight) {
          // Sort berdasarkan waktu Pagi ke Malam
          filteredTickets.sort((a, b) => a['waktu_k'].compareTo(b['waktu_k']));
        } else if (sortByNightToMorning) {
          // Sort berdasarkan waktu Malam ke Pagi
          filteredTickets.sort((a, b) => b['waktu_k'].compareTo(a['waktu_k']));
        }

        if (sortByLowToHigh) {
          // Sort berdasarkan harga terendah ke tertinggi
          filteredTickets
              .sort((a, b) => a['harga_jual'].compareTo(b['harga_jual']));
        } else if (sortByHighToLow) {
          // Sort berdasarkan harga tertinggi ke terendah
          filteredTickets
              .sort((a, b) => b['harga_jual'].compareTo(a['harga_jual']));
        }
      }
    });
  }

  // Menampilkan opsi sorting
  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Urut berdasarkan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                // Kategori Waktu
                const Text(
                  "Urutkan Berdasarkan Waktu",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                CheckboxListTile(
                  title: const Text("Pagi ke Malam"),
                  value: sortByMorningToNight,
                  onChanged: (bool? value) {
                    setStateModal(() {
                      if (value == true) {
                        sortByMorningToNight = true;
                        sortByNightToMorning = false; // Setel ke default
                      } else {
                        sortByMorningToNight =
                            false; // Jika diklik lagi, kembalikan ke default
                      }
                    });
                    _applySort(); // Terapkan sorting berdasarkan waktu
                  },
                ),
                CheckboxListTile(
                  title: const Text("Malam ke Pagi"),
                  value: sortByNightToMorning,
                  onChanged: (bool? value) {
                    setStateModal(() {
                      if (value == true) {
                        sortByNightToMorning = true;
                        sortByMorningToNight = false; // Setel ke default
                      } else {
                        sortByNightToMorning =
                            false; // Jika diklik lagi, kembalikan ke default
                      }
                    });
                    _applySort(); // Terapkan sorting berdasarkan waktu
                  },
                ),
                const Divider(),

                // Kategori Harga
                const Text(
                  "Urutkan Berdasarkan Harga",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                CheckboxListTile(
                  title: const Text("Harga Terendah ke Tertinggi"),
                  value: sortByLowToHigh,
                  onChanged: (bool? value) {
                    setStateModal(() {
                      if (value == true) {
                        sortByLowToHigh = true;
                        sortByHighToLow = false; // Setel ke default
                      } else {
                        sortByLowToHigh =
                            false; // Jika diklik lagi, kembalikan ke default
                      }
                    });
                    _applySort(); // Terapkan sorting berdasarkan harga
                  },
                ),
                CheckboxListTile(
                  title: const Text("Harga Tertinggi ke Terendah"),
                  value: sortByHighToLow,
                  onChanged: (bool? value) {
                    setStateModal(() {
                      if (value == true) {
                        sortByHighToLow = true;
                        sortByLowToHigh = false; // Setel ke default
                      } else {
                        sortByHighToLow =
                            false; // Jika diklik lagi, kembalikan ke default
                      }
                    });
                    _applySort(); // Terapkan sorting berdasarkan harga
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String keberangkatan = filteredTickets.isNotEmpty
        ? (filteredTickets[0]['keberangkatan'] ?? 'Tidak Diketahui')
        : 'Tidak Diketahui';
    final String tujuan = filteredTickets.isNotEmpty
        ? (filteredTickets[0]['tujuan'] ?? 'Tidak Diketahui')
        : 'Tidak Diketahui';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 158, 222),
        title: Text(
          '$keberangkatan - $tujuan',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFC2E3F7),
      body: Stack(
        children: [
          // Bagian utama (daftar tiket atau pesan kosong)
          filteredTickets.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada tiket yang ditemukan",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredTickets.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final tiket = filteredTickets[index];
                    return TicketCard(tiket: tiket);
                  },
                ),
          // FloatingActionButton untuk Filter dan Sort
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () => _showSortOptions(context),
                  label: const Text("Urut"),
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Map<String, dynamic> tiket;

  const TicketCard({Key? key, required this.tiket}) : super(key: key);

  Future<void> saveTicketId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id_transport', id); // Menyimpan ID sebagai int
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          //diganti dengan logo pada db
                          tiket['logo'] ?? '',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          //diganti dengan nama_transport pada db
                          tiket['nama_transport'] ?? "Maskapai",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12), // Jarak kolom
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      //disesuaikan dengan data keberangkatan, seperti contoh apabila surabaya berarti SBY apabila jakarta berarti JKT
                      _getSingkatan(tiket['keberangkatan'] ?? ""),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.indigo.shade400,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                              height: 24,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Flex(
                                    direction: Axis.horizontal,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                        (constraints.constrainWidth() / 6)
                                            .floor(),
                                        (index) => SizedBox(
                                              height: 1,
                                              width: 3,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                            )),
                                  );
                                },
                              ),
                            ),
                            Center(
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.indigo.shade300,
                                size: 24,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.pink.shade400,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      //disesuaikan dengan data tujuan, seperti contoh apabila surabaya berarti SBY apabila jakarta berarti JKT
                      _getSingkatan(tiket['tujuan'] ?? ""),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                        width: 100,
                        child: Text(
                          //disesuaikan dengan keberangkatan pada db
                          tiket['keberangkatan'] ?? '',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        )),
                    Text(
                      //sesuaikan dengan waktu perjalanan pada db
                      formatDurasi(tiket['l_waktu'] ?? 0),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                        width: 100,
                        child: Text(
                          //disesuaikan dengan tujuan pada db
                          tiket['tujuan'] ?? '',
                          textAlign: TextAlign.end,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        )),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      //disesuakan dengan waktu take off pada db
                      formatJam(tiket['waktu_k']),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      //diseusaikan dengan waktu landing pada db
                      formatJam(tiket['waktu_t']),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      //tanggal keberangkatan di db
                      tiket['tanggal_k'] ?? "",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      //tanggal keberangkatan di db
                      tiket['tanggal_t'] ?? "",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 20,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.grey.shade200),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Flex(
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              (constraints.constrainWidth() / 10).floor(),
                              (index) => SizedBox(
                                    height: 1,
                                    width: 5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade400),
                                    ),
                                  )),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: Colors.grey.shade200),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              // Gunakan Column untuk menggabungkan semua elemen
              children: [
                Row(
                  children: <Widget>[
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // kelas dari database
                          "Kelas ${tiket['kelas'] ?? ""}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          // Muatan bagasi dari database
                          'Bagasi ${tiket['muatan']} kg',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            // Harga dari database
                            formatHarga(double.tryParse(
                                    tiket['harga_jual'].toString()) ??
                                0.0),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16), // Jarak antar elemen
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Jarak antar elemen
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () async {
                          int transportId =
                              tiket['id']; // Contoh ID transportasi
                          await saveTicketId(
                              transportId); // Menyimpan ID ke SharedPreferences

                          print('id: $transportId');

                          // Navigasi ke halaman pesawatpage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const datakapal(),
                            ),
                          );
                        },
                        child: const Text(
                          "Pesan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
