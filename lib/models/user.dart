
import 'dart:convert';

import 'package:hive/hive.dart';
part 'user.g.dart';


@HiveType(typeId: 0)
class User extends HiveObject{

  @HiveField(0)
  final String token;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  User({
    required this.email, required this.token,  required this.username
  });

  factory User.fromJson(Map<String, dynamic> json)  {
    return User(
    email: json['email'],
    token: json['token'],
  username: json['username']
  );
}

}