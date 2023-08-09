import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:image_picker/image_picker.dart';


class EditProductController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  TextEditingController productNameC = TextEditingController();
  TextEditingController qtyC = TextEditingController();
  TextEditingController priceC = TextEditingController();

  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickerImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  Future<DocumentSnapshot<Object?>> getData(String docId) async {
    DocumentReference docRef = firestore.collection("products").doc(docId);
    return docRef.get();
  }

  void editProduct(String docId) async {
    DocumentReference docData = firestore.collection("products").doc(docId);
    try {
      if(productNameC.text.isNotEmpty && qtyC.text.isNotEmpty && priceC.text.isNotEmpty) {
        Map<String, dynamic> data = {
          "product_name": productNameC.text,
          "qty": qtyC.text,
          "price": priceC.text
        };
        if(image != null) {
          File file = File(image!.path);
          final path = 'files/${image!.name.split(".").last}';

          await storage.ref().child(path).putFile(file);

          String urlImage = await storage.ref().child(path).getDownloadURL();
          data.addAll({"image_food": urlImage});
        }
        await docData.update(data);

        image = null;

        Get.defaultDialog(
          title: "Berhasil",
          middleText: "Produk berhasil di ubah",
          onConfirm: () {
            Get.back();
            Get.back();
          },
          textConfirm: "Oke",
          barrierDismissible: false,
        );
      } else {
        Get.snackbar("Perhatian", "Semua kolom harus diisi !");
      }

    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "$e");
    }
  }
}
