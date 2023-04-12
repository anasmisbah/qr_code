// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    ProductModel({
       required this.code,
       required this.name,
       required this.productId,
      required  this.qty,
    });

    String code;
    String name;
    String productId;
    int qty;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"] ?? "",
        name: json["name"] ??"",
        productId: json["productId"]??"",
        qty: json["qty"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "productId": productId,
        "qty": qty,
    };
}
