import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String _getSingkatan(String kota) {
  final Map<String, String> singkatanKota = {
    'Surabaya': 'SBY',
    'Jakarta': 'JKT',
    'Bandung': 'BDG',
    'Yogyakarta': 'YOG',
    'Medan': 'MDN',
    'Makassar': 'MKS',
    'Semarang': 'SMG',
    'Denpasar': 'DPS',
    'Balikpapan': 'BPN',
    'Pontianak': 'PNK',
    'Palembang': 'PLM',
    'Padang': 'PDG',
    'Manado': 'MND',
    'Malang': 'MLG'
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

  DaftarTiketScreen({Key? key, required this.tickets}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DaftarTiketScreenState createState() => _DaftarTiketScreenState();
}

class _DaftarTiketScreenState extends State<DaftarTiketScreen> {
  // Variabel untuk menyimpan status filter dan sort
  List<dynamic> filteredTickets = [];
  bool? filterLionAir = false;
  bool? filterGaruda = false;
  bool? filterAirAsia = false;
  bool? filterSriwijayaAir = false;
  bool? filterCitilink = false;
  bool? filterBatikAir = false;
  bool? filterSingaporeAirlines = false;
  bool? filterEmirates = false;

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
  void _applyFilter() {
    setState(() {
      filteredTickets = widget.tickets.where((ticket) {
        bool isLionAir =
            filterLionAir == true && ticket['nama_transport'] == 'Lion Air';
        bool isGaruda =
            filterGaruda == true && ticket['nama_transport'] == 'Garuda';
        bool isAirAsia =
            filterAirAsia == true && ticket['nama_transport'] == 'AirAsia';
        bool isSriwijayaAir = filterSriwijayaAir == true &&
            ticket['nama_transport'] == 'Sriwijaya Air';
        bool isCitilink =
            filterCitilink == true && ticket['nama_transport'] == 'Citilink';
        bool isBatikAir =
            filterBatikAir == true && ticket['nama_transport'] == 'Batik Air';
        bool isSingaporeAirlines = filterSingaporeAirlines == true &&
            ticket['nama_transport'] == 'Singapore Airlines';
        bool isEmirates =
            filterEmirates == true && ticket['nama_transport'] == 'Emirates';

        // Filter berdasarkan maskapai
        return isLionAir ||
            isGaruda ||
            isAirAsia ||
            isSriwijayaAir ||
            isCitilink ||
            isBatikAir ||
            isSingaporeAirlines ||
            isEmirates ||
            (filterLionAir == false &&
                filterGaruda == false &&
                filterAirAsia == false &&
                filterSriwijayaAir == false &&
                filterCitilink == false &&
                filterBatikAir == false &&
                filterSingaporeAirlines == false &&
                filterEmirates == false);
      }).toList();
    });
  }

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

  // Menampilkan opsi filter
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // StatefulBuilder memungkinkan pembaruan status checkbox
          builder: (context, setStateModal) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Filter",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                CheckboxListTile(
                  title: const Text("Lion Air"),
                  value: filterLionAir,
                  onChanged: (bool? value) {
                    setState(() {
                      filterLionAir = value ?? false;
                    });
                    _applyFilter();
                    setStateModal(() {}); // Memperbarui status di dalam modal
                  },
                ),
                CheckboxListTile(
                  title: const Text("Garuda"),
                  value: filterGaruda,
                  onChanged: (bool? value) {
                    setState(() {
                      filterGaruda = value!;
                    });
                    _applyFilter();
                    setStateModal(() {}); // Memperbarui status di dalam modal
                  },
                ),
                CheckboxListTile(
                  title: const Text("AirAsia"),
                  value: filterAirAsia,
                  onChanged: (bool? value) {
                    setState(() {
                      filterAirAsia = value ?? false;
                    });
                    _applyFilter();
                    setStateModal(() {}); // Memperbarui status di dalam modal
                  },
                ),
                CheckboxListTile(
                  title: const Text("Sriwijaya Air"),
                  value: filterSriwijayaAir,
                  onChanged: (bool? value) {
                    setState(() {
                      filterSriwijayaAir = value ?? false;
                    });
                    _applyFilter();
                    setStateModal(() {}); // Memperbarui status di dalam modal
                  },
                ),
                CheckboxListTile(
                  title: const Text("Citilink"),
                  value: filterCitilink,
                  onChanged: (bool? value) {
                    setState(() {
                      filterCitilink = value ?? false;
                    });
                    _applyFilter();
                    setStateModal(() {}); // Memperbarui status di dalam modal
                  },
                ),
                CheckboxListTile(
                  title: const Text("Batik Air"),
                  value: filterBatikAir,
                  onChanged: (bool? value) {
                    setState(() {
                      filterBatikAir = value ?? false;
                    });
                    _applyFilter();
                    setStateModal(() {}); // Memperbarui status di dalam modal
                  },
                ),
                CheckboxListTile(
                  title: const Text("Singapore Airlines"),
                  value: filterSingaporeAirlines,
                  onChanged: (bool? value) {
                    setState(() {
                      filterSingaporeAirlines = value ?? false;
                    });
                    _applyFilter();
                    setStateModal(() {}); // Memperbarui status di dalam modal
                  },
                ),
                CheckboxListTile(
                  title: const Text("Emirates"),
                  value: filterEmirates,
                  onChanged: (bool? value) {
                    setState(() {
                      filterEmirates = value ?? false;
                    });
                    _applyFilter();
                    setStateModal(() {}); // Memperbarui status di dalam modal
                  },
                ),
              ],
            );
          },
        );
      },
    );
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
                FloatingActionButton.extended(
                  onPressed: () => _showFilterOptions(context),
                  label: const Text("Filter"),
                  icon: const Icon(Icons.filter_list),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Maskapai
            Text(
              tiket['maskapai'] ?? 'Nama Maskapai',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Keberangkatan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Keberangkatan",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      tiket['keberangkatan'] ?? '-',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                // Tujuan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tujuan",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      tiket['tujuan'] ?? '-',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tanggal dan Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tanggal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tanggal",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      tiket['tanggal'] ?? '-',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                // Harga
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Harga",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "Rp ${tiket['harga']?.toString() ?? '0'}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tombol Pesan
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  // Aksi ketika tombol pesan ditekan
                },
                child: const Text(
                  "Pesan Sekarang",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
