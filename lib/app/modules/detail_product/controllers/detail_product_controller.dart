import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/app/data/models/product_model.dart';

class DetailProductController extends GetxController {
  late TextEditingController codeC;
  late TextEditingController nameC;
  late TextEditingController qtyC;

  RxBool isLoading = false.obs;
  RxBool isLoadingDelete = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late ProductModel product;
  @override
  void onInit() {
    // TODO: implement onInit
    product = Get.arguments;
    codeC = TextEditingController(text: product.code);
    nameC = TextEditingController(text: product.name);
    qtyC = TextEditingController(text: product.qty.toString());
    super.onInit();
  }

  Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> data) async {
    try {
      await firestore.collection("products").doc(data['productId']).update(
        {
          "name": data['name'],
          "qty": data['qty'],
        },
      );
      return {"error": false, "message": "Berhasil mengubah product"};
    } catch (e) {
      print(e);
      return {"error": true, "message": "Tidak dapat mengubah product"};
    }
  }
  Future<Map<String, dynamic>> deleteProduct(String productId) async {
    try {
      await firestore.collection("products").doc(productId).delete();
      return {"error": false, "message": "Berhasil delete product"};
    } catch (e) {
      print(e);
      return {"error": true, "message": "Tidak dapat delete product"};
    }
  }
}
