import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(249, 33, 162, 201),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Update Database',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
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
                          Icon(Icons.upload, color: Colors.white),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Update",
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
                          // Form fields
                          const Text("Jenis Transportasi",
                              style: TextStyle(fontSize: 14)),
                          DropdownButtonFormField<String>(
                            items: ["Pesawat", "Kereta", "Kapal"]
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

                          const Text("Nama Transportasi",
                              style: TextStyle(fontSize: 14)),
                          const TextField(
                            decoration: InputDecoration(
                              hintText: "Masukan nama transportasi",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text("Upload Logo",
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.grey),
                                color: const Color(0xFFEEEEEE),
                              ),
                              child: _image == null
                                  ? const Icon(Icons.upload, size: 50)
                                  : Image.file(
                                      File(_image!.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Departure and destination
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Keberangkatan",
                                        style: TextStyle(fontSize: 14)),
                                    DropdownButtonFormField<String>(
                                      items: ["Jakarta", "Semarang", "Surabaya"]
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
                                      items: ["Surabaya", "Bali", "Batam"]
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

                          const Text("Jumlah Tiket Tersedia",
                              style: TextStyle(fontSize: 14)),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              hintText: "Masukan jumlah tiket tersedia",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text("Tanggal Keberangkatan",
                              style: TextStyle(fontSize: 14)),
                          const TextField(
                            decoration: InputDecoration(
                              hintText: "Masukan tanggal keberangkatan",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text("Tanggal Sampai Tujuan",
                              style: TextStyle(fontSize: 14)),
                          const TextField(
                            decoration: InputDecoration(
                              hintText: "Masukan tanggal sampai tujuan",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text("Waktu Takeoff",
                              style: TextStyle(fontSize: 14)),
                          const TextField(
                            decoration: InputDecoration(
                              hintText: "Masukan waktu takeoff",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 20),

                          const Text("Waktu Landing",
                              style: TextStyle(fontSize: 14)),
                          const TextField(
                            decoration: InputDecoration(
                              hintText: "Masukan waktu landing",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 20),

                          const Text("Bagasi", style: TextStyle(fontSize: 14)),
                          const TextField(
                            decoration: InputDecoration(
                              hintText: "Masukan kapasitas bagasi",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                      // Aksi ketika tombol ditekan
                    },
                    child: const Text(
                      "Update",
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
