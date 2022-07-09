import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:flutter_ecommerce/screens/status_check.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';


final boxA = Provider<List<User>>((ref) => []);
final boxB = Provider<List<CartItem>>((ref) => []);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartItemAdapter());
  final userBox = await Hive.openBox<User>('user');
  final cartBox = await Hive.openBox<CartItem>('carts');
  runApp(
      ProviderScope(
        overrides: [
          boxA.overrideWithValue(userBox.values.toList().cast<User>()),
          boxB.overrideWithValue(cartBox.values.toList().cast<CartItem>())
        ],
          child: Home()));
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatusScreen(),
    );
  }
}
