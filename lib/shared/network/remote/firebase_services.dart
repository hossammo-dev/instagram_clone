import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  //login
  static Future<UserCredential> login(
          {String? email, String? password}) async => await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);

  //register
  static Future<UserCredential> register(
          {String? email, String? password}) async =>
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);

  //log out
  static Future<void> logout() async => _auth.signOut();

  //save
  static Future<void> save({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) =>
      _db.collection(collection).doc(docId).set(data);

  //get
  static Future<DocumentSnapshot<Map<String, dynamic>>> get({
    required String collection,
    required String docId,
  }) async =>
      _db.collection(collection).doc(docId).get();

  //get all
  static Future<QuerySnapshot<Map<String, dynamic>>> getAll(
          {required String collection}) async =>
      await _db.collection(collection).get();

  //get stream
  static Stream<QuerySnapshot<Map<String, dynamic>>> getStream(
          {required String collection}) =>
      _db
          .collection(collection)
          .orderBy('created_at', descending: true)
          .snapshots();

  //update data
  static Future<void> update({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async =>
      _db.collection(collection).doc(docId).update(data);

  //delete data
  static Future<void> delete({
    required String collection,
    required String docId,
  }) async =>
      _db.collection(collection).doc(docId).delete();

  //save to storage
  static Future<String?> saveToStorage(
      {required File imageFile, required String path}) async {
    String? _imageUrl;
    await _storage.ref().child(path).putFile(imageFile).then(
        (value) => value.ref.getDownloadURL().then((url) => _imageUrl = url));
    return _imageUrl;
  }

}
