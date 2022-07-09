import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_ecommerce/api.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';


final productProvider = StateNotifierProvider<ProductProvider, List<Product>>((ref) => ProductProvider(ref: ref));

class ProductProvider extends StateNotifier<List<Product>>{
  ProductProvider({required this.ref}) : super([]) {
    getData();
  }

  StateNotifierProviderRef ref;

  Future<void> getData() async {
    final dio = Dio();
      try{
        final response = await dio.get(Api.baseUrl);
        state = (response.data as List).map((e) => Product.fromJson(e)).toList();
      } on DioError catch(err) {
        print(err);
        state = [
          Product(
              id: '',
              image: '',
              price: 0,
              product_detail: '',
              product_name: '${err.response}',
              public_id: ''
          )
        ];
      }
  }
}




final crudProvider = Provider((ref) => CrudProvider());

class CrudProvider {

  Future<String> addProduct({required String productName, required String productDetail, required XFile image, required int productPrice}) async {
    final dio = Dio();
    final user = Hive.box<User>('user').values.toList();
    try{
      FormData _formData = FormData.fromMap({
        'product_name' : productName,
        'product_detail' : productDetail,
        'photo' : await MultipartFile.fromFile(image.path),
        'price' : productPrice
      });
      final response = await dio.post(Api.createProduct, data: _formData,
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




  Future<String> updateProduct({required String productName, required String productDetail, XFile? image,
    String? publicId, required String id, required int productPrice}) async {
    final dio = Dio();
    final user = Hive.box<User>('user').values.toList();
    try{
      if(image == null) {
        final response = await dio.patch(Api.baseUrl + '/product/update/$id', data: {
          'product_name' : productName,
          'product_detail' : productDetail,
          'photo' : 'no need to update',
          'price' : productPrice
        },
            options: Options(
                headers: {
                  HttpHeaders.authorizationHeader : 'Bearer ${user[0].token}'
                }
            )
        );
      } else {
        FormData _formData = FormData.fromMap({
          'product_name' : productName,
          'product_detail' : productDetail,
          'photo' : await MultipartFile.fromFile(image.path),
          'price' : productPrice,
          'public_id' : publicId
        });
        final response = await dio.patch(Api.baseUrl + '/product/update/$id', data: _formData,
            options: Options(
                headers: {
                  HttpHeaders.authorizationHeader : 'Bearer ${user[0].token}'
                }
            )
        );
      }
      return 'success';
    } on DioError catch(err) {
      return '';
    }
  }


  Future<String> removeProduct({required String publicId, required String id}) async {
    final dio = Dio();
    final user = Hive.box<User>('user').values.toList();
    try{
        final response = await dio.delete(Api.baseUrl + '/products/remove/$id',
            data: {
              'public_id' : publicId
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







}
