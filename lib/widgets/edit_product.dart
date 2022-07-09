import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/provider/crudProvider.dart';
import 'package:flutter_ecommerce/provider/image_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class EditPage extends StatelessWidget {

  final Product product;
  EditPage(this.product);

  final productNameController = TextEditingController();
  final productDetailController = TextEditingController();
  final priceController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit page'),
          backgroundColor: Colors.purple,
        ),
        body: Consumer(builder: (context, ref, child) {
          final image = ref.watch(imageProvider).image;
          return Form(
              key: _form,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Container(
                    height:  460,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 15,),
                        Text(
                          'Edit Form',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 2,
                              color: Colors.blueGrey),
                        ),
                        TextFormField(
                          controller: productNameController..text = product.product_name,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'product name is required';
                            }
                            if (val.length > 40) {
                              return 'maximum product name length is 40';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'Product Name'),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'product detail is required';
                            }
                            if (val.length > 500) {
                              return 'maximum character length is 500';
                            }
                            return null;
                          },
                          controller: productDetailController..text = product.product_detail,
                          decoration: InputDecoration(hintText: 'Product Description'),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'product price is required';
                            }
                            return null;
                          },
                          controller: priceController..text = product.price.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Product Price'),
                        ),
                        InkWell(
                          onTap: () {
                            ref.read(imageProvider).getImage();
                          },
                          child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: image == null ? Image.network(product.image) : Image.file(
                                File(image.path),
                                fit: BoxFit.cover,
                              )),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              _form.currentState!.save();
                              if(_form.currentState!.validate()){
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                if(image == null){
                                  final response = await ref.read(crudProvider).updateProduct(
                                      id: product.id,
                                      productPrice: int.parse(priceController.text.trim()),
                                      productDetail: productDetailController.text.trim(),
                                      productName: productNameController.text.trim()
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
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  final response = await ref.read(crudProvider).updateProduct(
                                      image: image,
                                      id: product.id,
                                      publicId: product.public_id,
                                      productPrice: int.parse(priceController.text.trim()),
                                      productDetail: productDetailController.text.trim(),
                                      productName: productNameController.text.trim()
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
                                    Navigator.of(context).pop();
                                  }
                                }

                              }


                            },
                            child: Text('Submit')),

                      ],
                    ),
                  ),
                ),
              ));
        }));
  }
}