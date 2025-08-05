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

  Future<void> updateAchievement({
    required AchievementEntity achievement,
    File? newCoverImage,
    List<File>? newGalleryImages,
  });
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
  Future<void> updateAchievement({
    required AchievementEntity achievement,
    File? newCoverImage,
    List<File>? newGalleryImages,
  }) async {
    String coverImageUrl = achievement.coverImageUrl;
    List<String> galleryImageUrls = achievement.galleryImageUrls;

    // 1. Agar nayi cover image hai, to usay upload karo aur purani delete karo
    if (newCoverImage != null) {
      await _storage
          .refFromURL(achievement.coverImageUrl)
          .delete(); // Purani delete
      coverImageUrl = await _uploadImage(
        newCoverImage,
        'achievement_images/${DateTime.now().millisecondsSinceEpoch}_cover.jpg',
      ); // Nayi upload
    }

    // 2. Agar nayi gallery images hain, to unhein upload karo aur purani delete karo
    if (newGalleryImages != null && newGalleryImages.isNotEmpty) {
      for (final url in achievement.galleryImageUrls) {
        await _storage.refFromURL(url).delete(); // Purani delete
      }
      galleryImageUrls = [];
      for (int i = 0; i < newGalleryImages.length; i++) {
        final imageUrl = await _uploadImage(
          newGalleryImages[i],
          'achievement_images/${achievement.id}_gallery_$i.jpg',
        );
        galleryImageUrls.add(imageUrl);
      }
    }

    // 3. Firestore document ko nayi details ke saath update karo
    await _firestore.collection('achievements').doc(achievement.id).update({
      'name': achievement.name,
      'date': Timestamp.fromDate(achievement.date),
      'coverImageUrl': coverImageUrl,
      'galleryImageUrls': galleryImageUrls,
    });
  }
}
