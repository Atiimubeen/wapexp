import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wapexp/admin_app/features/achievements/data/models/achievement_model.dart';
import 'package:wapexp/admin_app/features/achievements/domain/entities/achievement_entity.dart';

abstract class AchievementRemoteDataSource {
  Future<void> addAchievement({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  });
  Stream<List<AchievementModel>> getAchievements();
  Future<void> deleteAchievement(AchievementEntity achievement);
  Future<void> updateAchievement(AchievementEntity achievement);
}

class AchievementRemoteDataSourceImpl implements AchievementRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AchievementRemoteDataSourceImpl({
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
  Future<void> addAchievement({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  }) async {
    final coverImageUrl = await _uploadImage(
      coverImage,
      'achievement_images/${DateTime.now().millisecondsSinceEpoch}_cover.jpg',
    );
    List<String> galleryUrls = [];
    for (int i = 0; i < galleryImages.length; i++) {
      final imageUrl = await _uploadImage(
        galleryImages[i],
        'achievement_images/${DateTime.now().millisecondsSinceEpoch}_gallery_$i.jpg',
      );
      galleryUrls.add(imageUrl);
    }
    await _firestore.collection('achievements').add({
      'name': name,
      'date': Timestamp.fromDate(date),
      'coverImageUrl': coverImageUrl,
      'galleryImageUrls': galleryUrls,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<AchievementModel>> getAchievements() {
    return _firestore
        .collection('achievements')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AchievementModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> deleteAchievement(AchievementEntity achievement) async {
    // Firestore se document delete karna
    await _firestore.collection('achievements').doc(achievement.id).delete();
    // Storage se cover image delete karna
    await _storage.refFromURL(achievement.coverImageUrl).delete();
    // Storage se gallery ki saari images delete karna
    for (final url in achievement.galleryImageUrls) {
      await _storage.refFromURL(url).delete();
    }
  }

  @override
  Future<void> updateAchievement(AchievementEntity achievement) async {
    await _firestore.collection('achievements').doc(achievement.id).update({
      'name': achievement.name,
      'date': Timestamp.fromDate(achievement.date),
    });
  }
}
