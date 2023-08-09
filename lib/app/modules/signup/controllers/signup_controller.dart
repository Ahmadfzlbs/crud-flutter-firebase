import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }

  Future<void> signup() async {
    isLoading.value = true;
    try{
      if(emailC.text.isNotEmpty && passC.text.isNotEmpty){
        if(GetUtils.isEmail(emailC.text)){
          await auth.createUserWithEmailAndPassword(
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
        Get.snackbar("Kesalahan", "Email dan password harus diisi");
      }
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if(e.code == "email-already-in-use"){
        Get.closeAllSnackbars();
        Get.snackbar("Kesalahan", "Email ini telah di gunakan");
      } else {
        print(e);
      }
    }
    catch (e) {
      isLoading.value = false;
      Get.snackbar("Kesalahan", "$e");
    }
  }

}
