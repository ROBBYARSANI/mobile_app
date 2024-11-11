import 'package:flutter/material.dart';

class datakereta extends StatefulWidget {
  const datakereta({super.key});

  @override
  State<datakereta> createState() => _datakeretapagestate();
}

class _datakeretapagestate extends State<datakereta> {
  int jumlahAnak = 0;
  int jumlahDewasa = 0;
  DateTime? tanggalBerangkat;

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

                          const Text("NIK", style: TextStyle(fontSize: 14)),
                          const TextField(
                            decoration: InputDecoration(
                              hintText: "Masukan NIK Sesuai dengan KTP",
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
                                      items: ["Jakarta", "Bandung"]
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
