import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> getData() {
    CollectionReference product = firestore.collection("products");
    return product.get();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference product = firestore.collection("products");
    return product.orderBy("time", descending: true).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamProduct() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("products").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Object?>> searchProduct() {
    CollectionReference product = firestore.collection("products");
    return product.where("product_name").snapshots();
  }

  Future<void> deleteProduct(String docId) async {
    DocumentReference docRef = firestore.collection("products").doc(docId);
    try{
      Get.defaultDialog(
        barrierDismissible: false,
        title: "Hapus data",
        middleText: "Apakah kamu yakin untuk menghapus data ini ?",
        onConfirm: () async {
          await docRef.delete();
          Get.back();
        },
        textConfirm: "Oke",
        textCancel: "Tidak"
      );
    } catch (e){

    }
  }

  void logout() async {
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Keluar",
        middleText: "Apakah kamu yakin untuk keluar aplikasi ?",
        onConfirm: () async {
          await FirebaseAuth.instance.signOut();
          Get.offAllNamed(Routes.LOGIN);
          Get.back();
        },
        textConfirm: "Oke",
        textCancel: "Tidak"
    );
  }
}
