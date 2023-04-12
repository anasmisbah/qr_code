import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/data/models/product_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: QrImage(
              data: controller.product.code,
              version: QrVersions.auto,
              size: 200,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.codeC,
            keyboardType: TextInputType.number,
            maxLength: 10,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: controller.qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Qty",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                controller.isLoading.value = true;
                if (controller.nameC.text.isNotEmpty &&
                    controller.qtyC.text.isNotEmpty) {
                  Map<String, dynamic> res = await controller.updateProduct({
                    "productId": controller.product.productId,
                    "name": controller.nameC.text,
                    "qty": int.tryParse(controller.qtyC.text) ?? 0,
                  });
                  Get.back();
                  Get.snackbar(res['error'] == true ? "Error" : "Berhasil",
                      res['message']);
                } else {
                  Get.snackbar('Error', 'Name dan qty wajib diiisi');
                }
                controller.isLoading.value = false;
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            child: Obx(
              () => Text(controller.isLoading.isFalse
                  ? "Update Product"
                  : "Loading..."),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () async {
              Get.defaultDialog(
                  middleText: "Are you sure to delete this product ?",
                  title: "Delete Product",
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.isLoadingDelete.isFalse) {
                          controller.isLoadingDelete.value = true;
                          Map<String, dynamic> res = await controller
                              .deleteProduct(controller.product.productId);
                          if (res['error'] == true) {
                            Get.snackbar('Error', res['message']);
                          } else {
                            Get.back();
                            Get.back();
                            Get.snackbar('Berhasil', res['message']);
                          }
                          controller.isLoadingDelete.value = false;
                        }
                      },
                      child: Obx(
                        () => controller.isLoadingDelete.isFalse
                            ? Text("Delete")
                            : Container(
                                padding: const EdgeInsets.all(2),
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              ),
                      ),
                    )
                  ]);
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(vertical: 20),
              foregroundColor: Colors.red,
            ),
            child: Obx(
              () => Text(
                controller.isLoading.isFalse ? "Delete Product" : "Loading...",
                style: TextStyle(
                  color: Colors.red.shade900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
