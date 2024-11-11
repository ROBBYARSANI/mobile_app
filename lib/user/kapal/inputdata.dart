import 'package:flutter/material.dart';

class kapalpage extends StatefulWidget {
  const kapalpage({super.key});

  @override
  State<kapalpage> createState() => _kapalpagestate();
}

class _kapalpagestate extends State<kapalpage> {
  int jumlahAnak = 0;
  int jumlahDewasa = 0;
  DateTime? tanggalBerangkat;

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
                          const TextField(
                            decoration: InputDecoration(
                              hintText: "Masukan nama lengkap",
                            ),
                          ),
                          const SizedBox(height: 20),

                          // TUJUAN
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Keberangkatan",
                                        style: TextStyle(fontSize: 14)),
                                    DropdownButtonFormField<String>(
                                      items: ["Surabaya", "Bali"]
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {},
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
                                      items: ["Surabaya", "Bali"]
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {},
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

                          // JUMLAH PESAN TIKET
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

                          // KELAS KURSI
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
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // TANGGAL
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

                          const Text("Nomor Telp / HP",
                              style: TextStyle(fontSize: 14)),
                          const TextField(
                            decoration: InputDecoration(
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

              //CO
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
                      //QWERTYUIO
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
