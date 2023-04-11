import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController(text: "admin@gmail.com");
  TextEditingController passC = TextEditingController(text: "123123");

  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;

}
