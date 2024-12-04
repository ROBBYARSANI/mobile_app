import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tiket/util/config/config.dart';

class PilihKursiController extends GetxController {
  var indexGerbong = 0.obs;
  var gerbong = <List<Map<String, dynamic>>>[].obs;

  Future<void> fetchKursi(String gerbongName) async {
    final Uri url = Uri.http(AppConfig.API_HOST,
        '/tiket_go/pesawat/get_kursi.php', {'gerbong': gerbongName});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        gerbong.value = [
          List<Map<String, dynamic>>.from(data['data'].map((kursi) => {
                "id": kursi['id'],
                "n_kursi": kursi['n_kursi'],
                "status": kursi['status'] == 1 ? "available" : "filled",
              }))
        ];
      }
    } else {
      Get.snackbar('Error', 'Gagal mengambil data kursi');
    }
  }

  Future<void> updateKursi(int id, int newStatus) async {
    final Uri url = Uri.http('localhost', '/update_kursi.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id_kursi": id, "status": newStatus}),
    );
    if (response.statusCode != 200) {
      Get.snackbar('Error', 'Gagal memperbarui status kursi');
    }
  }

  void selectKursi(int index) async {
    var kursi = gerbong[indexGerbong.value][index];
    if (kursi['status'] == "available") {
      kursi['status'] = "selected";
      await updateKursi(kursi['id'], 0); // Update ke status terisi
    } else if (kursi['status'] == "selected") {
      kursi['status'] = "available";
      await updateKursi(kursi['id'], 1); // Update ke status tersedia
    }
    update();
  }
}
