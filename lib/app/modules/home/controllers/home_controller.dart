import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code/app/data/models/product_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;
  void downloadCatalog() async {
    final pdf = pw.Document();

    //ambil data

    var getData = await firestore.collection("products").get();

    // reset all data
    allProducts.clear();
    for (var element in getData.docs) {
      allProducts.add(ProductModel.fromJson(element.data()));
    }

    // font

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> allData =
              List.generate(allProducts.length, (index) {
            ProductModel product = allProducts[index];
            return pw.TableRow(
              children: [
                // No
                pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Text(
                    "${index + 1}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                // Kode barang
                pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Text(
                    "${product.code}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                // Nama barang
                pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Text(
                    "${product.name}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                // Qty
                pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Text(
                    "${product.qty}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                // QR COde
                pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.BarcodeWidget(
                    color: PdfColor.fromHex("#000000"),
                    data: "${product.code}",
                    barcode: pw.Barcode.qrCode(),
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            );
          });
          return [
            pw.Center(
              child: pw.Text(
                "CATALOG PRODUCTS",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 24),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // No
                    pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "No",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Kode barang
                    pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Product Code",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Nama barang
                    pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Product Name",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Qty
                    pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Quantity",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // QR COde
                    pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "QR Code",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Isi data
                ...allData,
              ],
            )
          ];
        },
      ),
    );

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong di direktori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mydocument.pdf');

    // memasukkan data bytes ke file
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);
  }
}
