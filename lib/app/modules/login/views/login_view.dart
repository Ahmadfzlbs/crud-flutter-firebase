import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.25,
                ),
                Text(
                  "Log In",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: Get.height * 0.1,
                ),
                TextFormField(
                  controller: controller.emailC,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: controller.passC,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{8,}$');
                    if (value!.isEmpty) {
                      return ("Harap masukkan kata sandi");
                    } else if (!regex.hasMatch(value)) {
                      return ("Masukkan kata sandi minimal 8 karakter");
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      label: Text("Password"),
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                SizedBox(height: 30),
                Obx(
                  () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(Get.width, 30)),
                      onPressed: () async {
                        if (controller.isLoading.isFalse) {
                          await controller.login();
                        }
                      },
                      child: Text(controller.isLoading.isFalse
                          ? "Log In"
                          : "Tunggu...")),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () => Get.toNamed(Routes.SIGNUP),
                        child: Text("Sign Up")),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
