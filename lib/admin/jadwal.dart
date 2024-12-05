import 'dart:convert';
import 'package:tiket/util/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _jumlahTiketController = TextEditingController();
  final TextEditingController _waktuTakeoffController = TextEditingController();
  final TextEditingController _waktuLandingController = TextEditingController();
  final TextEditingController _kapasitasBagasiController =
      TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();

  String? jenisTransportasi;
  String? namaTransportasi;
  double? hargaJual;
  String? keberangkatan;
  String? tujuan;
  String? kelas;
  int? jumlahTiket;
  DateTime? tanggalBerangkat;
  DateTime? tanggalSampai;
  String? waktuTakeoff;
  String? waktuLanding;
  int? kapasitasBagasi;
  File? _image;

  final _formKey = GlobalKey<FormState>();

  Future<void> pilihTanggal(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          tanggalBerangkat = picked;
        } else {
          tanggalSampai = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  // Function to send data to the server
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      /*if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logo harus diupload')),
        );
        return;
      }*/
      try {
        // Prepare image data as base64
        String? imagePath;
        if (_image != null) {
          imagePath = _image?.path;
        }

        // Prepare data
        final data = {
          "jenis_transportasi": jenisTransportasi,
          "nama_transport": namaTransportasi,
          "harga_jual": hargaJual,
          "keberangkatan": keberangkatan,
          "tujuan": tujuan,
          "kelas": kelas,
          "stok": int.tryParse(_jumlahTiketController.text),
          "tanggal_k": tanggalBerangkat?.toIso8601String(),
          "tanggal_t": tanggalSampai?.toIso8601String(),
          "waktu_k": _waktuTakeoffController.text,
          "waktu_t": _waktuLandingController.text,
          "muatan": int.tryParse(_kapasitasBagasiController.text),
          if (imagePath != null) "logo": imagePath,
        };

        // Send request to the server
        final Uri url =
            Uri.http(AppConfig.API_HOST, '/tiket_go/admin/update.php');

        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
        print('Request URL: $url');
        print('Request Body: ${jsonEncode(data)}');
        print('Response Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['success']) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data berhasil disimpan')),
            );
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Gagal menyimpan data: ${responseData['message']}')),
            );
          }
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal terhubung ke server')),
          );
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
            child: Form(
              key: _formKey,
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
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
                                onChanged: (value) {
                                  jenisTransportasi = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pilih jenis transportasi';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),

                              const Text("Nama Transportasi",
                                  style: TextStyle(fontSize: 14)),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Masukan nama transportasi",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama Transportasi tidak boleh kosong';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  namaTransportasi = value;
                                },
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
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

                              const Text("Harga Jual",
                                  style: TextStyle(fontSize: 14)),
                              TextFormField(
                                controller: _hargaJualController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Masukkan harga jual",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Harga jual tidak boleh kosong';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Masukkan angka yang valid';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  hargaJual = double.tryParse(value ?? '0');
                                },
                              ),
                              const SizedBox(height: 20),

                              // tujuan , keberangkatan
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Keberangkatan",
                                            style: TextStyle(fontSize: 14)),
                                        Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text.isEmpty) {
                                              return const Iterable<
                                                  String>.empty();
                                            }
                                            return [
                                              "Surabaya, pasar turi",
                                              "Surabaya, gubeng",
                                              "Semarang, semarang poncol",
                                              "Semarang, semarang tawang",
                                              "Yogyakarta, lempuyangan",
                                              "Yogyakarta, tugu",
                                              "Bandung, bandung",
                                              "Bandung, kiaracondong",
                                              "Jakarta, gambir",
                                              "Jakarta, pasar senen",
                                              "Malang, malang",
                                              "Malang, malang kota lama",
                                              "Solo, solo balapan",
                                              "Solo, purwosari",
                                              "Cirebon, cirebon kejaksan",
                                              "Cirebon, cirebon prujakan",
                                              "Surabaya, wonokromo",
                                              "Surabaya, kandangan",
                                              "Semarang, brumbung",
                                              "Semarang, jerakah",
                                              "Yogyakarta, sentolo",
                                              "Yogyakarta, maguwo",
                                              "Bandung, padalarang",
                                              "Bandung, cimahi",
                                              "Jakarta, juanda",
                                              "Jakarta, tanah abang",
                                              "Malang, kepanjen",
                                              "Malang, singosari",
                                              "Solo, jebres",
                                              "Solo, palur",
                                              "Cirebon, arjawinangun",
                                              "Cirebon, babakan",
                                              "Sidoarjo, sidoarjo",
                                              "Sidoarjo, tanggulangin",
                                              "Pasuruan, pasuruan",
                                              "Pasuruan, bangil",
                                              "Banyuwangi, banyuwangi baru",
                                              "Banyuwangi, ketapang",
                                              "Probolinggo, probolinggo",
                                              "Probolinggo, leces",
                                              "Madiun, madiun",
                                              "Madiun, caruban",
                                              "Kediri, kediri",
                                              "Kediri, pare",
                                              "Tulungagung, tulungagung",
                                              "Tulungagung, campurdarat",
                                              "Blitar, blitar",
                                              "Blitar, garum",
                                              "Jember, jember",
                                              "Jember, rambipuji",
                                              "Garut, garut",
                                              "Garut, limbangan",
                                              "Bogor, bogor",
                                              "Bogor, cilebut",
                                              "Bekasi, bekasi",
                                              "Bekasi, cikarang",
                                              "Depok, depok baru",
                                              "Depok, citayam",
                                              "Tangerang, tangerang",
                                              "Tangerang, batuceper",
                                              "Medan, medan",
                                              "Medan, amplas",
                                              "Palembang, kertapati",
                                              "Palembang, simpang",
                                              "Lampung, tanjung karang",
                                              "Lampung, kedaton",
                                              "Surabaya, Indonesia",
                                              "Jakarta, Indonesia",
                                              "Denpasar, Indonesia",
                                              "Medan, Indonesia",
                                              "Makassar, Indonesia",
                                              "Yogyakarta, Indonesia",
                                              "Bandung, Indonesia",
                                              "Semarang, Indonesia",
                                              "Balikpapan, Indonesia",
                                              "Manado, Indonesia",
                                              "Lombok, Indonesia",
                                              "Malang, Indonesia",
                                              "Palembang, Indonesia",
                                              "Pekanbaru, Indonesia",
                                              "Banjarmasin, Indonesia",
                                              "Pontianak, Indonesia",
                                              "Jayapura, Indonesia",
                                              "Ambon, Indonesia",
                                              "Ternate, Indonesia",
                                              "Sorong, Indonesia",
                                              "Tanjung Perak, Surabaya",
                                              "Tanjung Priok, Jakarta",
                                              "Belawan, Medan",
                                              "Makassar, Makassar",
                                              "Surabaya",
                                              "Bali",
                                              "Jakarta",
                                              "Medan",
                                              "Makassar",
                                              "Yogyakarta",
                                              "Bandung",
                                              "Singapore",
                                              "Kuala Lumpur",
                                              "Sydney",
                                            ].where((String option) {
                                              return option
                                                  .toLowerCase()
                                                  .contains(textEditingValue
                                                      .text
                                                      .toLowerCase());
                                            });
                                          },
                                          onSelected: (String selection) {
                                            setState(() {
                                              keberangkatan = selection;
                                            });
                                          },
                                          fieldViewBuilder: (context,
                                              controller,
                                              focusNode,
                                              onEditingComplete) {
                                            return TextFormField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              decoration: const InputDecoration(
                                                hintText: 'Keberangkatan',
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Pilih keberangkatan';
                                                }
                                                return null;
                                              },
                                            );
                                          },
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Tujuan",
                                            style: TextStyle(fontSize: 14)),
                                        Autocomplete<String>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text.isEmpty) {
                                              return const Iterable<
                                                  String>.empty();
                                            }
                                            return [
                                              "Surabaya, pasar turi",
                                              "Surabaya, gubeng",
                                              "Semarang, semarang poncol",
                                              "Semarang, semarang tawang",
                                              "Yogyakarta, lempuyangan",
                                              "Yogyakarta, tugu",
                                              "Bandung, bandung",
                                              "Bandung, kiaracondong",
                                              "Jakarta, gambir",
                                              "Jakarta, pasar senen",
                                              "Malang, malang",
                                              "Malang, malang kota lama",
                                              "Solo, solo balapan",
                                              "Solo, purwosari",
                                              "Cirebon, cirebon kejaksan",
                                              "Cirebon, cirebon prujakan",
                                              "Surabaya, wonokromo",
                                              "Surabaya, kandangan",
                                              "Semarang, brumbung",
                                              "Semarang, jerakah",
                                              "Yogyakarta, sentolo",
                                              "Yogyakarta, maguwo",
                                              "Bandung, padalarang",
                                              "Bandung, cimahi",
                                              "Jakarta, juanda",
                                              "Jakarta, tanah abang",
                                              "Malang, kepanjen",
                                              "Malang, singosari",
                                              "Solo, jebres",
                                              "Solo, palur",
                                              "Cirebon, arjawinangun",
                                              "Cirebon, babakan",
                                              "Sidoarjo, sidoarjo",
                                              "Sidoarjo, tanggulangin",
                                              "Pasuruan, pasuruan",
                                              "Pasuruan, bangil",
                                              "Banyuwangi, banyuwangi baru",
                                              "Banyuwangi, ketapang",
                                              "Probolinggo, probolinggo",
                                              "Probolinggo, leces",
                                              "Madiun, madiun",
                                              "Madiun, caruban",
                                              "Kediri, kediri",
                                              "Kediri, pare",
                                              "Tulungagung, tulungagung",
                                              "Tulungagung, campurdarat",
                                              "Blitar, blitar",
                                              "Blitar, garum",
                                              "Jember, jember",
                                              "Jember, rambipuji",
                                              "Garut, garut",
                                              "Garut, limbangan",
                                              "Bogor, bogor",
                                              "Bogor, cilebut",
                                              "Bekasi, bekasi",
                                              "Bekasi, cikarang",
                                              "Depok, depok baru",
                                              "Depok, citayam",
                                              "Tangerang, tangerang",
                                              "Tangerang, batuceper",
                                              "Medan, medan",
                                              "Medan, amplas",
                                              "Palembang, kertapati",
                                              "Palembang, simpang",
                                              "Lampung, tanjung karang",
                                              "Lampung, kedaton",
                                              "Surabaya, Indonesia",
                                              "Jakarta, Indonesia",
                                              "Denpasar, Indonesia",
                                              "Medan, Indonesia",
                                              "Makassar, Indonesia",
                                              "Yogyakarta, Indonesia",
                                              "Bandung, Indonesia",
                                              "Semarang, Indonesia",
                                              "Balikpapan, Indonesia",
                                              "Manado, Indonesia",
                                              "Lombok, Indonesia",
                                              "Malang, Indonesia",
                                              "Palembang, Indonesia",
                                              "Pekanbaru, Indonesia",
                                              "Banjarmasin, Indonesia",
                                              "Pontianak, Indonesia",
                                              "Jayapura, Indonesia",
                                              "Ambon, Indonesia",
                                              "Ternate, Indonesia",
                                              "Sorong, Indonesia",
                                              "Tanjung Perak, Surabaya",
                                              "Tanjung Priok, Jakarta",
                                              "Belawan, Medan",
                                              "Makassar, Makassar",
                                              "Pelabuhan Bakauheni, Lampung",
                                              "Pelabuhan Merak, Banten",
                                              "Pelabuhan Benoa, Denpasar",
                                              "Pelabuhan Tanjung Emas, Semarang",
                                              "Pelabuhan Teluk Bayur, Padang",
                                              "Pelabuhan Boom Baru, Palembang",
                                              "Pelabuhan Pontianak, Pontianak",
                                              "Pelabuhan Balikpapan, Balikpapan",
                                              "Pelabuhan Bitung, Bitung",
                                              "Pelabuhan Tenau, Kupang",
                                              "Pelabuhan Soekarno-Hatta, Makassar",
                                              "Pelabuhan Ambon, Ambon",
                                              "Pelabuhan Sorong, Sorong",
                                              "Pelabuhan Jayapura, Jayapura",
                                              "Pelabuhan Tanjung Balai Karimun, Karimun",
                                              "Pelabuhan Dumai, Dumai",
                                              "Pelabuhan Tanjung Pandan, Belitung",
                                              "Pelabuhan Sibolga, Sibolga",
                                              "Pelabuhan Kupang, Kupang",
                                              "Pelabuhan Lembar, Lombok",
                                              "Pelabuhan Labuan Bajo, Labuan Bajo",
                                              "Pelabuhan Tarakan, Tarakan",
                                              "Pelabuhan Sampit, Sampit",
                                              "Pelabuhan Kumai, Kotawaringin Barat",
                                              "Pelabuhan Fakfak, Fakfak",
                                              "Pelabuhan Sarmi, Sarmi",
                                              "Pelabuhan Saumlaki, Saumlaki",
                                              "Pelabuhan Timika, Timika",
                                              "Pelabuhan Morotai, Morotai",
                                              "Pelabuhan Natuna, Natuna",
                                              "Pelabuhan Ketapang, Banyuwangi",
                                              "Pelabuhan Padangbai, Karangasem",
                                              "Pelabuhan Probolinggo, Probolinggo",
                                              "Pelabuhan Singkil, Aceh Singkil",
                                              "Pelabuhan Sabang, Sabang",
                                              "Pelabuhan Bima, Bima",
                                              "Pelabuhan Tanjung Batu, Kutai Kartanegara",
                                              "Pelabuhan Malundung, Tarakan",
                                              "Pelabuhan Lewoleba, Lembata",
                                              "Pelabuhan Tual, Tual",
                                              "Pelabuhan Nabire, Nabire",
                                              "Pelabuhan Biak, Biak",
                                            ].where((String option) {
                                              return option
                                                  .toLowerCase()
                                                  .contains(textEditingValue
                                                      .text
                                                      .toLowerCase());
                                            });
                                          },
                                          onSelected: (String selection) {
                                            setState(() {
                                              tujuan = selection;
                                            });
                                          },
                                          fieldViewBuilder: (context,
                                              controller,
                                              focusNode,
                                              onEditingComplete) {
                                            return TextFormField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              decoration: const InputDecoration(
                                                hintText: 'Tujuan',
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Pilih tujuan';
                                                }
                                                return null;
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              const Text("Kelas",
                                  style: TextStyle(fontSize: 14)),
                              DropdownButtonFormField<String>(
                                items: ["Ekonomi", "Bisnis", "Eksekutif"]
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  kelas = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pilih Kelas';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Jumlah tiket
                              const Text("Jumlah Tiket",
                                  style: TextStyle(fontSize: 14)),
                              TextFormField(
                                controller: _jumlahTiketController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Masukan jumlah tiket",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Jumlah tiket tidak boleh kosong';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Masukkan angka yang valid';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  jumlahTiket = int.tryParse(value ?? '0');
                                },
                              ),
                              const SizedBox(height: 20),

                              // Tanggal sampai keberangkatan
                              const Text("Tanggal Berangkat"),
                              TextFormField(
                                readOnly: true,
                                onTap: () => pilihTanggal(context, true),
                                decoration: InputDecoration(
                                  hintText: tanggalBerangkat != null
                                      ? "${tanggalBerangkat!.year}-${tanggalBerangkat!.month.toString().padLeft(2, '0')}-${tanggalBerangkat!.day.toString().padLeft(2, '0')}"
                                      : "Masukan tanggal berangkat",
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (tanggalBerangkat == null) {
                                    return 'Tanggal keberangkatan wajib dipilih';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Tanggal sampai tujuan
                              const Text("Tanggal Sampai"),
                              TextFormField(
                                readOnly: true,
                                onTap: () => pilihTanggal(context, false),
                                decoration: InputDecoration(
                                  hintText: tanggalSampai != null
                                      ? "${tanggalSampai!.year}-${tanggalSampai!.month.toString().padLeft(2, '0')}-${tanggalSampai!.day.toString().padLeft(2, '0')}"
                                      : "Masukan tanggal sampai",
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (tanggalBerangkat == null) {
                                    return 'Tanggal sampai wajib dipilih';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              // Waktu takeoff
                              const Text("Waktu Takeoff",
                                  style: TextStyle(fontSize: 14)),
                              TextFormField(
                                controller: _waktuTakeoffController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  hintText: "Masukan waktu takeoff",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (tanggalBerangkat == null) {
                                    return 'Waktu takeoff wajib dipilih';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  waktuTakeoff = value;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Waktu landing
                              const Text("Waktu Landing",
                                  style: TextStyle(fontSize: 14)),
                              TextFormField(
                                controller: _waktuLandingController,
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                  hintText: "Masukan waktu landing",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (tanggalBerangkat == null) {
                                    return 'Waktu landing wajib dipilih';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  waktuLanding = value;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Kapasitas bagasi
                              const Text("Bagasi",
                                  style: TextStyle(fontSize: 14)),
                              TextFormField(
                                controller: _kapasitasBagasiController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Masukan kapasitas bagasi (Kg)",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (tanggalBerangkat == null) {
                                    return 'Kapasitas bagasi wajib dipilih';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  kapasitasBagasi = int.tryParse(value ?? '0');
                                },
                              ),
                              const SizedBox(height: 20),

                              // Update button
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                    onPressed: _submitForm,
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
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
