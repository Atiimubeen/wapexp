import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wapexp/features/sessions/domain/entities/session_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    required super.id,
    required super.name,
    required super.date,
    required super.coverImageUrl,
    required super.galleryImageUrls,
  });

  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SessionModel(
      id: doc.id,
      name: data['name'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      coverImageUrl: data['coverImageUrl'] ?? '',
      galleryImageUrls: List<String>.from(data['galleryImageUrls'] ?? []),
    );
  }
}
