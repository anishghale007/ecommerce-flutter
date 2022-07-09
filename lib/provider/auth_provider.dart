import 'package:dio/dio.dart';
import 'package:flutter_ecommerce/api.dart';
import 'package:flutter_ecommerce/main.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';


final userProvider = StateNotifierProvider<UserProvider, List<User>>((ref) => UserProvider(ref: ref));

class UserProvider extends StateNotifier<List<User>>{
  UserProvider({required this.ref}) : super(ref.read(boxA));

  
  StateNotifierProviderRef ref;

  Future<String> userLogin({required String email, required String password}) async{
    final dio = Dio();
    try{
     final response = await dio.post(Api.userLogin, data: {
       'email' : email,
       'password' : password
     });
     final user = User.fromJson(response.data);  // changing the response into a model
     Hive.box<User>('user').add(user);      // if not added in box then it wont be saved locally
     state = [user];      // adding a single user model into the empty array
     return 'Success';
    } on DioError catch (err) {
     return '${err.message}';
    }
  }



  Future<String> userSignUp({required String email, required String password, required String username}) async{
    final dio = Dio();
    try{
      final response = await dio.post(Api.userSignUp, data: {
        'email' : email,
        'password' : password,
        'full_name' : username
      });
      final user = User.fromJson(response.data);  // changing the response into a model
      Hive.box<User>('user').add(user);      // if not added in box then it wont be saved locally
      state = [user];      // adding a single user model into the empty array
      return 'Success';
    } on DioError catch (err) {
      return '${err.message}';
    }
  }



  void clearBox() {
    Hive.box<User>('user').clear();
    state = [];
  }


}