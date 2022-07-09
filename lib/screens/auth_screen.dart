import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/provider/auth_provider.dart';
import 'package:flutter_ecommerce/provider/image_provider.dart';
import 'package:flutter_ecommerce/provider/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('auth screen'),
          backgroundColor: Colors.purple,
        ),
        body: Consumer(builder: (context, ref, child) {
          final isLogin = ref.watch(loginProvider);
          final isLoad = ref.watch(loadingProvider);
          print(isLoad);
          return Form(
              key: _form,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    height: isLogin ? 390 : 560,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 15,),
                        Text(
                          isLogin ? 'Login Form' : 'SignUp Form',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 2,
                              color: Colors.blueGrey),
                        ),
                        if (isLogin == false) TextFormField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'username is required';
                            }
                            if (val.length > 30) {
                              return 'maximum user length is 30';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'username'),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'email is required';
                            }
                            if (!val.contains('@')) {
                              return 'please provide valid email address';
                            }
                            return null;
                          },
                          controller: mailController,
                          decoration: InputDecoration(hintText: 'email'),
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'password is required';
                            }
                            if (val.length > 20) {
                              return 'maximum password length is 20';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'password'),
                        ),
                        // if (isLogin == false) InkWell(
                        //   onTap: () {
                        //     ref.read(imageProvider).getImage();
                        //   },
                        //   child: Container(
                        //       height: 150,
                        //       decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.black)),
                        //       child: image == null ? Center(child: Text('select an image')) : Image.file(
                        //         File(image.path),
                        //         fit: BoxFit.cover,
                        //       )),
                        // ),
                        Container(
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () async {
                                _form.currentState!.save();
                                ref.read(loadingProvider.notifier).toggle();
                                FocusScope.of(context).unfocus();
                                if(_form.currentState!.validate()){
                                  if(isLogin){
                                    final response = await ref.read(userProvider.notifier).userLogin(
                                        email: mailController.text.trim(),
                                        password: passwordController.text.trim()
                                    );
                                    if(response != 'Success'){
                                      ref.read(loadingProvider.notifier).toggle();
                                      Get.showSnackbar(GetSnackBar(
                                        duration: Duration(seconds: 1),
                                        title:'some error occurred',
                                        message: response,
                                      ));
                                    }

                                  }else{
                                    final response = await ref.read(userProvider.notifier).userSignUp(
                                        email: mailController.text.trim(),
                                        password: passwordController.text.trim(),
                                        username: nameController.text.trim()
                                    );

                                    if(response != 'Success'){
                                      ref.read(loadingProvider.notifier).toggle();
                                      Get.showSnackbar(GetSnackBar(
                                        duration: Duration(seconds: 1),
                                        title:'some error occurred',
                                        message: response,
                                      ));
                                    }
                                  }
                                }
                              },
                              child:isLoad ?   Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('loading please wait', style: TextStyle(fontSize: 16),),
                                  SizedBox(width: 15,),
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                ],
                              ) :Text('Submit')),
                        ),
                        Row(
                          children: [
                            Text(isLogin
                                ? 'Don\'t have account ?'
                                : 'Already have an account ?'),
                            TextButton(
                                onPressed: () {
                                  ref.read(loginProvider.notifier).toggle();
                                },
                                child: Text( isLogin ? 'SignUp' : 'Login'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        }));
  }
}
