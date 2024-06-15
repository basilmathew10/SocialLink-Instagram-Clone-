import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/Resources/AuthMethods.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  bool isdataloading = true;
  User? user;
  Future<User> refreshUser() async {
    log("inside");
    try {
      user = (await AuthMethods().getUserDetails()) as User?;
      isdataloading = false;
    } catch (e) {
      isdataloading = true;
    }
    return user!;
  }
  // User? user;
  // final AuthMethods _authMethods = AuthMethods();

  // // User get getUser => _user!;

  // Future<User> refreshUser() async {
  //   User user = await _authMethods.getUserDetails();
  //   user = user;
  //   notifyListeners();
  //   return user;
  // }
}