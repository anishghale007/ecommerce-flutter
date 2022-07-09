import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce/main.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';



final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) => CartProvider(ref: ref));

class CartProvider extends StateNotifier<List<CartItem>>{
  CartProvider({required this.ref}) : super(ref.read(boxB));

  StateNotifierProviderRef ref;

  String addCartItem(Product product){
    if(state.isEmpty) {
      final newCartItem = CartItem(
          price: product.price,
          id: product.id,
          imageUrl: product.image,
          quantity: 1,
          title: product.product_name,
          total: product.price
      );
      Hive.box<CartItem>('carts').add(newCartItem);
      state = [newCartItem];
      return 'success';
    } else {
      final cart = state.firstWhere((element) => element.id == product.id, orElse: (){
        return CartItem(
            price: 0,
            id: '',
            imageUrl: '',
            quantity: 0,
            title: 'no available',
            total: 0
        );
      });
      if(cart.title == 'not available') {
        final newCartItem = CartItem(
            price: product.price,
            id: product.id,
            imageUrl: product.image,
            quantity: 1,
            title: product.product_name,
            total: product.price
        );
        Hive.box<CartItem>('carts').add(newCartItem);
        state = [newCartItem];
        return 'success';
      }
      return 'some';
    }

  }

  void addSingleCart(CartItem cartItem){
    cartItem.quantity = cartItem.quantity + 1;
    cartItem.total = cartItem.price * (cartItem.quantity + 1);
    cartItem.save();
    state = [
      for(final element in state)
        if(element == cartItem) cartItem  else element
    ];
  }

  void removeSingleCart(CartItem cartItem){
    if(cartItem.quantity > 1) {
      cartItem.quantity = cartItem.quantity - 1;
      cartItem.total = cartItem.price * (cartItem.quantity - 1);
      cartItem.save();
      state = [
        for(final element in state)
          if(element == cartItem) cartItem  else element
      ];
    }
  }

  int get total {
    int total = 0;
    state.forEach((element) {
      total += element.quantity * element.price;
    });
    return total;
  }


  void clearBox(){
    Hive.box<CartItem>('carts').clear();
    state = [];
  }



}