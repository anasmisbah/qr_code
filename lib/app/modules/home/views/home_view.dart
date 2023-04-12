import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';
import 'package:qr_code/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;
          switch (index) {
            case 0:
              title = "Add Product";
              icon = Icons.post_add_rounded;
              onTap = () => Get.toNamed(Routes.ADD_PRODUCT);
              break;
            case 1:
              title = "Products";
              icon = Icons.list_alt_outlined;
              onTap = () => Get.toNamed(Routes.PRODUCTS);
              break;
            case 2:
              title = "QR Code";
              icon = Icons.qr_code;
              onTap = () => print("open camera");
              break;
            case 3:
              title = "Catalog";
              icon = Icons.document_scanner_outlined;
              onTap = () => print("open pdf");

              break;
            default:
          }
          return Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(9),
            child: InkWell(
              borderRadius: BorderRadius.circular(9),
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      icon,
                      size: 50,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> res = await Get.find<AuthController>().logout();
          if (res['error'] == true) {
            Get.snackbar('Error', res['message']);
          } else {
            Get.offAllNamed(Routes.LOGIN);
          }
        },
        child: Icon(
          Icons.logout,
        ),
      ),
    );
  }
}
