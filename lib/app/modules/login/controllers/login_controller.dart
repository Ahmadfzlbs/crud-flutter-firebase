import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      if(emailC.text.isNotEmpty && passC.text.isNotEmpty){
        if(GetUtils.isEmail(emailC.text)){
          await auth.signInWithEmailAndPassword(
              email: emailC.text,
              password: passC.text
          );
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Perhatian", "Harap masukan email yang valid !");
        }
      } else {
        Get.closeAllSnackbars();
        Get.snackbar("Perhatian", "Email dan password harus diisi !");
      }
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == "user-not-found") {
        Get.closeAllSnackbars();
        Get.snackbar("Kesalahan", "Email dengan pengguna ini tidak di temukan !");
      } else if (e.code == "wrong-password") {
        Get.closeAllSnackbars();
        Get.snackbar("Kesalahan", "Password yang anda masukkan salah !");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Kesalahan", "Tidak dapat login");
    }
  }
}
