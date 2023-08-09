import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  TextEditingController productNameC = TextEditingController();
  TextEditingController qtyC = TextEditingController();
  TextEditingController priceC = TextEditingController();

  final ImagePicker picker = ImagePicker();

  XFile? image;
  FilePickerResult? result;
  PlatformFile? pickedFile;

  void pickerImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  void uploadFile() async {
    result = await FilePicker.platform.pickFiles();
    if(result == null) return;
    pickedFile = result!.files.first;
    update();
  }

  Future<void> addProduct() async {
    CollectionReference product = await firestore.collection("products");
    try {
      isLoading.value = true;
      String timeNow = DateTime.now().toIso8601String();
      if(productNameC.text.isNotEmpty && qtyC.text.isNotEmpty && priceC.text.isNotEmpty && image != null){
        Map<String, dynamic> data = {
          "product_name": productNameC.text,
          "qty": qtyC.text,
          "price": priceC.text,
          "time": timeNow,

        };
        if(image != null) {
          File file = File(image!.path);
          final path = 'files/${image!.name}';

          await storage.ref().child(path).putFile(file);

          String urlImage = await storage.ref().child(path).getDownloadURL();
          data.addAll({"image_food": urlImage});
        }

        await product.add(data);

        Get.defaultDialog(
          title: "Berhasil",
          middleText: "Produk berhasil di tambahkan",
          onConfirm: () {
            Get.back();
            Get.back();
          },
          textConfirm: "Oke",
          barrierDismissible: false,
        );
        isLoading.value = false;
      } else {
        Get.closeAllSnackbars();
        Get.snackbar("Perhatian", "Semua kolom harus diisi");
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "$e");
    } finally {
      update();
    }
  }
}
