import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/provider/cart_provider.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../models/product.dart';

class DetailPage extends StatelessWidget {
  final Product product;
  DetailPage(this.product);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: height * 0.4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rs. ${product.price}', style: TextStyle(fontSize: 20, color: Colors.white),),
                            ],
                          ),
                          SizedBox(width: 200),
                          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border, color: Colors.white,))
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          product.product_detail,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return Container(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                final response = ref.read(cartProvider.notifier).addCartItem(product);
                                if(response == 'success') {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1500),
                                      content: Text('Successfully added to cart'),
                                      action: SnackBarAction(label: 'Go to cart', onPressed: (){
                                        Get.to(() => CartScreen(), transition: Transition.leftToRight);
                                      },),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1500),
                                    content: Text('Already added to cart'),
                                    action: SnackBarAction(label: 'Go to cart', onPressed: (){
                                      Get.to(() => CartScreen(), transition: Transition.leftToRight);
                                    },),
                                  ));
                                }
                              },
                              child: Text('Add to Cart', style: TextStyle(
                                  fontSize: 20, color: Colors.black),)),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 25, left: 15, right: 10),
              child: Column(
                children: [
                  Text(product.product_name, style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 240,
                          width: 240,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Hero(
                                  tag: "img-${product.image}",
                                  child: Image.network(product.image, fit: BoxFit.cover,)))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
