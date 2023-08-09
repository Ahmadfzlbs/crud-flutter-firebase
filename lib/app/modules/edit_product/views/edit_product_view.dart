import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/edit_product_controller.dart';

class EditProductView extends GetView<EditProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Produk'),
          centerTitle: true,
        ),
        body: FutureBuilder<DocumentSnapshot<Object?>>(
          future: controller.getData(Get.arguments),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {

              var data = snapshot.data!.data() as Map<String, dynamic>;
              controller.productNameC.text = data["product_name"];
              controller.qtyC.text = data["qty"];
              controller.priceC.text = data["price"];

              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        GetBuilder<EditProductController>(
                          builder: (c) {
                            if(c.image != null){
                              return Container(
                                color: Colors.white,
                                child: Image.file(
                                    File(c.image!.path)
                                ),
                              );
                            } else {
                              if(data["image_food"] != null) {
                                return Container(
                                  color: Colors.white,
                                  child: Image.network(data["image_food"],
                                    fit: BoxFit.cover,
                                    )
                                  );
                              } else {
                                return Text("Tidak ada gambar");
                              }
                            }
                          }
                        ),
                        TextButton(
                          child: Text("Pilih Image"),
                          onPressed: ()=> controller.pickerImage(),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: controller.productNameC,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(30)
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if(value!.isEmpty){
                          return ("Nama Produk harus diisi");
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          label: Text("Nama Produk"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.blue)
                          )
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: controller.qtyC,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(3),// for mobile
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if(value!.isEmpty){
                          return ("Jumlah Produk harus diisi");
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          label: Text("Jumlah Produk"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.blue)
                          )
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: controller.priceC,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(7)
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if(value!.isEmpty){
                          return ("Harga Produk harus diisi");
                        } else {
                          return value.length < 3 ? "Minimal mengisi 3 karakter" : null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          label: Text("Harga Produk"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.blue)
                          )
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(Get.width, 30)
                        ),
                        onPressed: () => controller.editProduct(Get.arguments),
                        child: Text("Edit Produk")
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        )
    );
  }
}
