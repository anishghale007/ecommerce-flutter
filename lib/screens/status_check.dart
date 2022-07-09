import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:flutter_ecommerce/screens/auth_screen.dart';
import 'package:flutter_ecommerce/screens/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StatusScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<User>>(
      valueListenable: Hive.box<User>('user').listenable(),
      builder: (context, box, widget) {
          final user = box.values.toList().cast<User>();
            return user.isEmpty ? AuthScreen() : MainScreen();
            }
        );
      }
  }

