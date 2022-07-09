import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/provider/auth_provider.dart';
import 'package:flutter_ecommerce/provider/crudProvider.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:flutter_ecommerce/widgets/detail_page.dart';
import 'package:flutter_ecommerce/widgets/drawer_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final productData = ref.watch(productProvider);
        return Scaffold(
            appBar: AppBar(
              title: Text('Sample Shop'),
              backgroundColor: Colors.purple,
              actions: [
                TextButton.icon(onPressed: () {
                  Get.to(() => CartScreen(), transition: Transition.leftToRight);
                },
                  icon: Icon(Icons.shopping_cart, color: Colors.white,),
                  label: Text('Cart', style: TextStyle(color: Colors.white),),
                )
              ],
            ),
            drawer: DrawerWidget(),
            body: productData.isEmpty ? Center(
              child: CircularProgressIndicator(color: Colors.purple,),)
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GridView.builder(
              itemCount: productData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    mainAxisExtent: 200
                  ),
                  itemBuilder: (context, index) {
                  final product = productData[index];
                    return GridTile(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => DetailPage(product), transition: Transition.leftToRight);
                          },
                          splashColor: Colors.black54,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                              child: Hero(
                                tag: "img-${product.image}",
                                child: Ink.image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(product.image),
                                ),
                              ),
                          ),
                        ),
                        footer: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 30,
                          color: Colors.black,
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(product.product_name, style: TextStyle(color: Colors.white),),
                              Text('${product.price}', style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                    );
                  }
            ),
                )
        );
      }
    );
  }
}
