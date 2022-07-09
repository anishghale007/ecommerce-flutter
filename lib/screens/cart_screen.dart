import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/provider/cart_provider.dart';
import 'package:flutter_ecommerce/provider/order_provider.dart';
import 'package:flutter_ecommerce/screens/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Cart Page'),
      ),
      body: Consumer(builder: (context, ref, child) {
        final cartData = ref.watch(cartProvider);
        final total = ref.watch(cartProvider.notifier).total;
        return cartData.isEmpty ? Container(
          child: Center(
            child: Text('No items added in your cart'),
          ),
        ) : Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: cartData.length,
                  itemBuilder: (context, index) {
                    final cart = cartData[index];
                    return Card(
                      margin: EdgeInsets.all(22),
                      shadowColor: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: Row(
                            children: [
                              Image.network(
                                cart.imageUrl,
                                height: 140,
                                width: 140,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  Text(
                                    cart.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Rs ${cart.price}',
                                  ),
                                ],
                              ),
                              SizedBox(width: 45),
                              Column(
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).addSingleCart(cart);
                                    },
                                    child: Icon(Icons.add),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30)))),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${cart.quantity}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  OutlinedButton(
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).removeSingleCart(cart);
                                    },
                                    child: Icon(Icons.remove),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30)))),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Price', style: TextStyle(fontSize: 18, color: Colors.grey),),
                          Text('Rs $total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(onPressed: () async {
                          final response = await ref.read(orderProvider.notifier).addOrder(
                              carts: cartData,
                              total: total
                          );
                          if(response == 'success') {
                            ref.refresh(orderProvider.notifier);
                            ref.read(cartProvider.notifier).clearBox();
                            Get.offAll(() => MainScreen(), transition: Transition.leftToRight);
                          }

                        }, child: Text('Checkout'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
