import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class DaftarTiketScreen extends StatelessWidget {
  final List<dynamic> tickets;

  DaftarTiketScreen({Key? key, required this.tickets}) : super(key: key);

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
              value: false,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: const Text("Garuda"),
              value: false,
              onChanged: (bool? value) {},
            ),
          ],
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Urut berdasarkan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListTile(
              title: const Text("Harga"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Waktu"),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String keberangkatan = tickets.isNotEmpty
        ? (tickets[0]['keberangkatan'] ?? 'Tidak Diketahui')
        : 'Tidak Diketahui';
    final String tujuan = tickets.isNotEmpty
        ? (tickets[0]['tujuan'] ?? 'Tidak Diketahui')
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
          tickets.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada tiket yang ditemukan",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
              : ListView.builder(
                  itemCount: tickets.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final tiket = tickets[index];
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
                    bottomRight: Radius.circular(24))),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      //kelas db
                      "Kelas ${tiket['kelas'] ?? ""}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    Text(
                      //disesuaikan dengan nilai muatan pada db
                      'Bagasi ${tiket['muatan']} kg',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    //harga db
                    formatHarga(
                        double.tryParse(tiket['harga_jual'].toString()) ?? 0.0),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
