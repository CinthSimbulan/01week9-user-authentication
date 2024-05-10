/*
  Created by: Claizel Coubeili Cepe
  Date: updated April 26, 2023
  Description: Sample todo app with Firebase 
*/
import 'dart:convert';

class myUser {
  String? id;
  String firstname;
  String lastname;
  String email;

  myUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  // Factory constructor to instantiate object from json format
  factory myUser.fromJson(Map<String, dynamic> json) {
    return myUser(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email']);
  }

  static List<myUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<myUser>((dynamic d) => myUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(myUser item) {
    return {
      'id': item.id,
      'firstname': item.firstname,
      'lastname': item.lastname,
      'email': item.email,
    };
  }
}
