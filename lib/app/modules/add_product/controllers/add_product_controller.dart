import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  TextEditingController codeC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController qtyC = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      DocumentReference<Map<String, dynamic>> res =
          await firestore.collection("products").add(data);
      await firestore.collection("products").doc(res.id).update(
        {"productId": res.id},
      );
      return {"error": false, "message": "Berhasil menambah product"};
    } catch (e) {
      print(e);
      return {"error": true, "message": "Tidak dapat menambah product"};
    }
  }
}
