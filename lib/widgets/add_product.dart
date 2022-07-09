import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/provider/crudProvider.dart';
import 'package:flutter_ecommerce/provider/image_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class CreatePage extends StatelessWidget {

  final productNameController = TextEditingController();
  final productDetailController = TextEditingController();
  final priceController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('create page'),
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
                          'Create Form',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 2,
                              color: Colors.blueGrey),
                        ),
                        TextFormField(
                          controller: productNameController,
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
                            if (val.length > 200) {
                              return 'maximum character length is 200';
                            }
                            return null;
                          },
                          controller: productDetailController,
                          decoration: InputDecoration(hintText: 'Product Description'),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'product price is required';
                            }
                            return null;
                          },
                          controller: priceController,
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
                              child: image == null ? Center(child: Text('select an image')) : Image.file(
                                File(image.path),
                                fit: BoxFit.cover,
                              )),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              _form.currentState!.save();
                              FocusScope.of(context).unfocus();
                              if(_form.currentState!.validate()){
                                if(image == null){
                                  Get.dialog(AlertDialog(
                                    title: Text('please select an image'),
                                    actions: [
                                      IconButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ));
                                }else{
                                  final response = await ref.read(crudProvider).addProduct(
                                    image: image,
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