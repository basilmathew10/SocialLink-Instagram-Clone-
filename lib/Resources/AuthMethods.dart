import 'dart:developer';
import 'package:social_media_app/Models.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? downloadUrl;



  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    log("user ==" + currentUser.toString());
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    log("model ===" + documentSnapshot.toString());
    return model.User.fromSnap(documentSnapshot);
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }
}