import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';
import 'package:qr_code/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => TextField(
              autocorrect: false,
              controller: controller.passC,
              obscureText: controller.isHidden.value,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.isHidden.toggle(),
                  icon: Icon(
                    controller.isHidden.isFalse
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                controller.isLoading.value = true;
                if (controller.emailC.text.isNotEmpty &&
                    controller.passC.text.isNotEmpty) {
                  Map<String, dynamic> res =
                      await Get.find<AuthController>().login(
                    controller.emailC.text,
                    controller.passC.text,
                  );
                  if (res['error'] == true) {
                    Get.snackbar('Error', res['message']);
                  } else {
                    Get.offAllNamed(Routes.HOME);
                  }
                } else {
                  Get.snackbar('Error', 'Email dan password wajib diiisi');
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
              () => Text(controller.isLoading.isFalse ? "Login" : "Loading..."),
            ),
          ),
        ],
      ),
    );
  }
}
