import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase CRUD'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => controller.logout(), icon: Icon(Icons.logout))
          ],
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(Get.width * 0.4, 30)
                          ),
                          onPressed: () => Get.toNamed(Routes.ADD_PRODUCT),
                          child: Text("Tambah Produk")
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(Get.width * 0.4, 30)
                          ),
                          onPressed: () {},
                          child: Text("Hapus Semua")
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text("Search Product"),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue)
                      )
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot<Object?>>(
              stream: controller.streamData(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.active){
                  var listProduct = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: listProduct.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ListTile(
                        leading: ClipOval(
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.grey,
                            child: Image.network("${(listProduct[index].data() as Map<String, dynamic>)["image_food"]}",fit: BoxFit.cover,),
                          ),
                        ),
                        title: Text("${(listProduct[index].data() as Map<String, dynamic>)["product_name"]}"),
                        subtitle: Text("Rp : ${(listProduct[index].data() as Map<String, dynamic>)["price"]}"),
                        onTap: () => Get.toNamed(Routes.EDIT_PRODUCT, arguments: listProduct[index].id),
                        trailing: IconButton(
                          onPressed: ()=> controller.deleteProduct(listProduct[index].id),
                          icon: Icon(Icons.delete, color: Colors.red,),),
                      )
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            ),
          ],
        )
    );
  }
}
