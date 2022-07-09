import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/location/location_check.dart';
import 'package:flutter_ecommerce/provider/auth_provider.dart';
import 'package:flutter_ecommerce/provider/login_provider.dart';
import 'package:flutter_ecommerce/widgets/add_product.dart';
import 'package:flutter_ecommerce/widgets/customize_product.dart';
import 'package:flutter_ecommerce/widgets/order_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';


class DrawerWidget extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ref) {
    final data = ref.watch(userProvider);
          return Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                      padding: EdgeInsets.only(top: 120, left: 15),
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          image: DecorationImage(
                              opacity: 0.5,
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/background.jpg')
                          )
                      ),
                      child: Text(data[0].email, style: TextStyle(color: Colors.white),)),
                  ListTile(
                    leading: Icon(Icons.account_circle_rounded, size: 30,),
                    title: Text(data[0].username),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).pop();
                      Get.to(() => CreatePage(), transition: Transition.leftToRight);
                    },
                    leading: Icon(Icons.add_business_outlined, size: 30,),
                    title: Text('Add Product'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).pop();
                      Get.to(() => ProductManage(), transition: Transition.leftToRight);
                    },
                    leading: Icon(Icons.edit, size: 30,),
                    title: Text('Customize Product'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).pop();
                      Get.to(() => OrderHistory(), transition: Transition.leftToRight);
                    },
                    leading: Icon(Icons.timer, size: 30,),
                    title: Text('Order History'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).pop();
                      Get.to(() => LocationCheck(), transition: Transition.leftToRight);
                    },
                    leading: Icon(Icons.add_location_sharp, size: 30,),
                    title: Text('Location'),
                  ),
                  Divider(),
                  ListTile(
                    onTap: (){
                      ref.read(loadingProvider.notifier).toggle();
                      Navigator.of(context).pop();
                      ref.read(userProvider.notifier).clearBox();
                    },
                    leading: Icon(Icons.exit_to_app, size: 30,),
                    title: Text('sign out'),
                  )
                ],
              )
          );
  }
}