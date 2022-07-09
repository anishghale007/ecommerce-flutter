import 'package:hive/hive.dart';
part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late int quantity;

  @HiveField(3)
  late int price;

  @HiveField(4)
  late String imageUrl;

  @HiveField(5)
  late int total;

  CartItem(
      {required this.price,
      required this.id,
      required this.imageUrl,
      required this.quantity,
      required this.title,
      required this.total});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        price: json['price'],
        id: json['id'],
        imageUrl: json['imageUrl'],
        quantity: json['quantity'],
        title: json['title'],
        total: json['total']);
  }

  Map<String, dynamic> toJson() {
    return {
      'price': this.price,
      'id': this.id,
      'title': this.title,
      'imageUrl': this.imageUrl,
      'quantity': this.quantity,
      'total': this.total
    };
  }
}
