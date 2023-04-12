import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/data/models/product_model.dart';
import 'package:qr_code/app/routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamProducts(),
          builder: (context, snapProduct) {
            if (snapProduct.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapProduct.data!.docs.isEmpty) {
              return Center(
                child: Text("No Product"),
              );
            }
            List<ProductModel> products = [];
            for (var element in snapProduct.data!.docs) {
              products.add(ProductModel.fromJson(element.data()));
            }
            return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: products.length,
              itemBuilder: (context, index) {
                ProductModel product = products[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Get.toNamed(Routes.DETAIL_PRODUCT,arguments: product);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.code,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(product.name),
                                Text("Jumlah : ${product.qty}"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: QrImage(
                              data: product.code,
                              version: QrVersions.auto,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
