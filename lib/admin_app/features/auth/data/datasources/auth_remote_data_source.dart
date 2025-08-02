import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wapexp/admin_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required File? image,
  });
  Future<void> logIn({required String email, required String password});
  Future<void> logOut();
  Stream<UserModel?> get user;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRemoteDataSourceImpl({
    required auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _storage = storage;

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required File? image,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) throw Exception('User creation failed.');

    String? imageUrl;
    if (image != null) {
      final ref = _storage.ref('user_images').child('${user.uid}.jpg');
      await ref.putFile(image);
      imageUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'isAdmin': false,
    });
  }

  @override
  Future<void> logIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) {
      if (firebaseUser == null) return null;
      return _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((doc) => UserModel.fromFirestore(doc));
    });
  }
}
