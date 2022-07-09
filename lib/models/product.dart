

class Product {

  late String id;
  late String product_name;
  late String product_detail;
  late int price;
  late String public_id;
  late String image;

  Product({
    required this.id,
    required this.image,
    required this.price,
    required this.product_detail,
    required this.product_name,
    required this.public_id
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
    id: json['_id'],
    image: json['image'],
    price: json['price'],
    product_detail: json['product_detail'],
    product_name: json['product_name'],
    public_id: json['public_id']
  );
  }

}