import 'package:flutter_ecommerce/models/cart_item.dart';

class Order{

  late int amount;
  late String dateTime;
  late List<CartItem> products;

  Order({
   required this.products,
   required this.amount,
   required this.dateTime
});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        products: (json['products'] as List).map((e) => CartItem.fromJson(e)).toList(),
        amount: json['amount'],
        dateTime: json['dateTime']
    );
  }


}