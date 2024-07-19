import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      //sign in user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info it doesn't already exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      // In thông tin email đã đăng nhập thành công
      debugPrint('Đăng nhập thành công: ${userCredential.user?.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // In thông tin email và password đã cố gắng đăng nhập
      debugPrint('Email: $email');
      debugPrint('Password: $password');
      // In thông tin lỗi từ Firebase
      debugPrint('Lỗi đăng nhập: ${e.code}, ${e.message}');
      throw Exception(e.code); // Ném lỗi để xử lý bên ngoài
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    try {
      //create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user info in a separate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
  //errors
}
