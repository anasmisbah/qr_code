import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.codeC,
            keyboardType: TextInputType.number,
            maxLength: 10,
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
                if (controller.codeC.text.isNotEmpty &&
                    controller.nameC.text.isNotEmpty &&
                    controller.qtyC.text.isNotEmpty) {
                  Map<String, dynamic> res = await controller.addProduct({
                    "code": controller.codeC.text,
                    "name": controller.nameC.text,
                    "qty": int.tryParse(controller.qtyC.text) ?? 0,
                  });
                  Get.back();
                  Get.snackbar(res['error'] == true ? "Error" : "Berhasil",
                      res['message']);
                } else {
                  Get.snackbar('Error', 'Code, Name dan qty wajib diiisi');
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
              () => Text(
                  controller.isLoading.isFalse ? "Add Product" : "Loading..."),
            ),
          ),
        ],
      ),
    );
  }
}
