import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wapexp/admin_app/features/sessions/data/models/session_model.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';

abstract class SessionRemoteDataSource {
  Future<void> addSession({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  });
  Stream<List<SessionModel>> getSessions();
  Future<void> deleteSession(SessionEntity session);
  Future<void> updateSession(SessionEntity session);
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  SessionRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firestore = firestore,
       _storage = storage;

  Future<String> _uploadImage(File image, String path) async {
    final ref = _storage.ref(path);
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  @override
  Future<void> addSession({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  }) async {
    final coverImageUrl = await _uploadImage(
      coverImage,
      'session_images/${DateTime.now().millisecondsSinceEpoch}_cover.jpg',
    );
    List<String> galleryUrls = [];
    for (int i = 0; i < galleryImages.length; i++) {
      final imageUrl = await _uploadImage(
        galleryImages[i],
        'session_images/${DateTime.now().millisecondsSinceEpoch}_gallery_$i.jpg',
      );
      galleryUrls.add(imageUrl);
    }
    await _firestore.collection('sessions').add({
      'name': name,
      'date': Timestamp.fromDate(date),
      'coverImageUrl': coverImageUrl,
      'galleryImageUrls': galleryUrls,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<SessionModel>> getSessions() {
    return _firestore
        .collection('sessions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SessionModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> deleteSession(SessionEntity session) async {
    await _firestore.collection('sessions').doc(session.id).delete();
    await _storage.refFromURL(session.coverImageUrl).delete();
    for (final url in session.galleryImageUrls) {
      await _storage.refFromURL(url).delete();
    }
  }

  @override
  Future<void> updateSession(SessionEntity session) async {
    await _firestore.collection('sessions').doc(session.id).update({
      'name': session.name,
      'date': Timestamp.fromDate(session.date),
    });
  }
}
