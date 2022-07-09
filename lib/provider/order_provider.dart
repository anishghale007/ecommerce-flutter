import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_ecommerce/api.dart';
import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/cart_item.dart';
import '../models/user.dart';



final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) => OrderProvider());

class OrderProvider extends StateNotifier<List<Order>>{
  OrderProvider() : super([]){
    getOrderHistory();
  }      //default constructor


  Future<String> addOrder({required List<CartItem> carts, required int total}) async {
    final dio = Dio();
    final user = Hive.box<User>('user').values.toList();
    try{
      final response = await dio.post(Api.createOrder, data: {
        'amount' : total,
        'dateTime' : DateTime.now().toIso8601String(),
        'products' : carts.map((e) => e.toJson()).toList(),     //sends the list model into map to the backend
      },
          options: Options(
              headers: {
                HttpHeaders.authorizationHeader : 'Bearer ${user[0].token}'
              }
          )
      );
      return 'success';
    } on DioError catch(err) {
      return '';
    }
  }



  Future<void> getOrderHistory() async {
    final dio = Dio();
    final user = Hive.box<User>('user').values.toList();
    try{
      final response = await dio.get(Api.orderHistory,
          options: Options(
              headers: {
                HttpHeaders.authorizationHeader : 'Bearer ${user[0].token}'
              }
          )
      );
      final data = (response.data as List).map((e) => Order.fromJson(e)).toList();
      state = data;
    } on DioError catch(err) {
      print(err);
      state = [];
    }
  }



}