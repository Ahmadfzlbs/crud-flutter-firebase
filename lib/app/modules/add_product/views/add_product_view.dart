import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String docId = auth.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Produk'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Center(
                child: GetBuilder<AddProductController>(
                    builder: (c) {
                  if (c.image != null) {
                    return Container(
                      color: Colors.white,
                      child: Image.file(File(c.image!.path)),
                    );
                  } else {
                    return Text("Tidak ada gambar");
                  }
                }),
              ),
              TextButton(
                child: Text("Pilih Image"),
                onPressed: () => controller.pickerImage(),
              ),
              TextFormField(
                controller: controller.productNameC,
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Nama Produk harus diisi");
                  }
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    label: Text("Nama Produk"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue))),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: controller.qtyC,
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(3), // for mobile
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Jumlah Produk harus diisi");
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: Text("Jumlah Produk"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue))),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: controller.priceC,
                inputFormatters: [new LengthLimitingTextInputFormatter(7)],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Harga Produk harus diisi");
                  } else {
                    return value.length < 3
                        ? "Minimal mengisi 3 karakter"
                        : null;
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: Text("Harga Produk"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue))),
              ),
              SizedBox(height: 30),
              Obx(() =>
                  ElevatedButton(
                      style:
                      ElevatedButton.styleFrom(fixedSize: Size(Get.width, 30)),
                      onPressed: () {
                        if(controller.isLoading.isFalse){
                          controller.addProduct();
                        }
                      },
                      child: Text(controller.isLoading.isFalse ? "Tambah" : "Tunggu..."))
              )
            ],
          ),
        ));
  }
}
