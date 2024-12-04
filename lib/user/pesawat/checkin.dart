import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiket/util/config/config.dart';

class PilihKursiView extends StatefulWidget {
  @override
  _PilihKursiViewState createState() => _PilihKursiViewState();
}

class _PilihKursiViewState extends State<PilihKursiView> {
  List<Map<String, dynamic>> gerbong = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKursi('A'); // Ambil data kursi untuk gerbong 'A'
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
  Future<void> updateKursi(int id, String newStatus) async {
    final Uri url =
        Uri.http(AppConfig.API_HOST, '/tiket_go/kereta/update_kursi.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"id_kursi": id, "status": newStatus == 'available' ? 1 : 0}),
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
    }
  }

  // Menangani pemilihan kursi
  void selectKursi(int index) async {
    var kursi = gerbong[index];
    String newStatus =
        kursi['status'] == 'available' ? 'selected' : 'available';

    await updateKursi(kursi['id'], newStatus);

    setState(() {
      kursi['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Kursi',
          style: TextStyle(
            color: Colors.white, // Warna teks putih
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
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
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiket/user/kereta/inputdata.dart';

class PilihTiketController extends GetxController {
  var indexGerbong = 0.obs;
  List<List<Map<String, dynamic>>> gerbong = [
    List.generate(28, (index) => {"status": "available"}),
    List.generate(28, (index) => {"status": "available"}),
  ];

  void gantiGerbong(int index) {
    indexGerbong.value = index;
  }

  void selectKursi(int index) {
    if (gerbong[indexGerbong.value][index]["status"] == "available") {
      gerbong[indexGerbong.value][index]["status"] = "selected";
    } else if (gerbong[indexGerbong.value][index]["status"] == "selected") {
      gerbong[indexGerbong.value][index]["status"] = "available";
    }
    update();
  }
}

class Checkin extends StatelessWidget {
  const Checkin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pilih Kursi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PilihTiketView(),
      initialBinding: BindingsBuilder(() {
        Get.put(PilihTiketController());
      }),
    );
  }
}

class PilihTiketView extends GetView<PilihTiketController> {
  const PilihTiketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pilih Kursi",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => datakereta()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/bg_home_wave.jpg"),
              ),
            ),
          ),
          Column(
            children: [
              // Hilangkan SizedBox di sini karena AppBar sudah ada di atas
              // Bagian teks dan header
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ekonomi (A)",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Ambarawa 1 - 3A",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemStatus(
                      status: "Tersedia",
                      color: Color(0x558D8D8D),
                    ),
                    ItemStatus(
                      status: "Terisi",
                      color: Color(0xFFFF8B2D),
                    ),
                    ItemStatus(
                      status: "Dipilih",
                      color: Color(0xFF2196F3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Gerbong",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 100),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: ["A", "B", "C", "D"]
                                      .map(
                                        (label) => Text(
                                          label,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Obx(
                                    () => Column(
                                      children: List.generate(
                                        controller.gerbong.length,
                                        (index) => GestureDetector(
                                          onTap: () =>
                                              controller.gantiGerbong(index),
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black38,
                                              ),
                                              color: controller
                                                          .indexGerbong.value ==
                                                      index
                                                  ? const Color(0xFF2196F3)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text("${index + 1}"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(
                                  () => GridView.builder(
                                    padding: const EdgeInsets.all(70),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      crossAxisCount: 4,
                                    ),
                                    itemCount: controller
                                        .gerbong[controller.indexGerbong.value]
                                        .length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () =>
                                          controller.selectKursi(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black38,
                                          ),
                                          color: controller.gerbong[controller
                                                          .indexGerbong.value]
                                                      [index]["status"] ==
                                                  "available"
                                              ? const Color(0x558D8D8D)
                                              : controller.gerbong[controller
                                                              .indexGerbong
                                                              .value][index]
                                                          ["status"] ==
                                                      "filled"
                                                  ? const Color(0xFFFF8B2D)
                                                  : const Color(0xFF2196F3),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        fixedSize: Size(Get.width * 0.8, 50),
                      ),
                      child: const Text("Pilih Kursi")),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemStatus extends StatelessWidget {
  const ItemStatus({
    super.key,
    required this.status,
    required this.color,
  });

  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          status,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}*/
