import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wapexp/features/achievements/domain/entities/achievement_entity.dart';

class AchievementModel extends AchievementEntity {
  const AchievementModel({
    required super.id,
    required super.name,
    required super.date,
    required super.coverImageUrl,
    required super.galleryImageUrls,
  });

  factory AchievementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AchievementModel(
      id: doc.id,
      name: data['name'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      coverImageUrl: data['coverImageUrl'] ?? '',
      galleryImageUrls: List<String>.from(data['galleryImageUrls'] ?? []),
    );
  }
}
