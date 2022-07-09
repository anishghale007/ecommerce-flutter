import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/provider/crudProvider.dart';
import 'package:flutter_ecommerce/widgets/edit_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class ProductManage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
          builder: (context, ref, child) {
            final products = ref.watch(productProvider);
        return products.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.purple,),) : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              child: ListTile(
                leading: Container(
                    width: 120,
                    child: Image.network(product.image, fit: BoxFit.cover,),),
                title: Text(product.product_name),
                trailing: Container(
                  width: 100,
                  child: Consumer(
                    builder: (context, ref, child) {
                      return Row(
                        children: [
                          IconButton(onPressed: () {
                            Get.to(() => EditPage(product),
                                transition: Transition.leftToRight);
                          }, icon: Icon(Icons.edit)),
                          IconButton(onPressed: () {
                            Get.defaultDialog(
                                title: 'Wait',
                                content: Text(
                                    'Are you sure you want to remove this product?'),
                                actions: [
                                  TextButton(onPressed: () async {
                                    Navigator.of(context).pop();
                                    final response = await ref.read(crudProvider).removeProduct(
                                        publicId: product.public_id,
                                        id: product.id
                                    );
                                    if(response != 'success'){
                                      // ref.read(loadingProvider.notifier).toggle();
                                      Get.showSnackbar(GetSnackBar(
                                        duration: Duration(seconds: 1),
                                        title:'some error occurred',
                                        message: response,
                                      ));
                                    } else {
                                      ref.refresh(productProvider.notifier);
                                      print('Success');
                                    }
                                  }, child: Text('Yes')),
                                  TextButton(onPressed: () async {
                                    Navigator.of(context).pop();
                                  }, child: Text('No')),
                                ]
                            );
                          }, icon: Icon(Icons.delete)),
                        ],
                      );
                    }
                  ),
                ),
              ),
            );
          }
        );
      }),
    );
  }
}
