import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wapexp/admin_app/features/announcements/data/models/announcement_model.dart';
import 'package:wapexp/admin_app/features/announcements/domain/entities/announcement_entity.dart';

abstract class AnnouncementRemoteDataSource {
  Future<void> addAnnouncement({
    required String title,
    required String description,
  });
  Stream<List<AnnouncementModel>> getAnnouncements();
  Future<void> deleteAnnouncement(String id);
  Future<void> updateAnnouncement(AnnouncementEntity announcement);
}

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final FirebaseFirestore _firestore;
  AnnouncementRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<void> addAnnouncement({
    required String title,
    required String description,
  }) async {
    await _firestore.collection('announcements').add({
      'title': title,
      'description': description,
      'date': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<AnnouncementModel>> getAnnouncements() {
    return _firestore
        .collection('announcements')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AnnouncementModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    await _firestore.collection('announcements').doc(id).delete();
  }

  @override
  Future<void> updateAnnouncement(AnnouncementEntity announcement) async {
    await _firestore.collection('announcements').doc(announcement.id).update({
      'title': announcement.title,
      'description': announcement.description,
      'date': Timestamp.fromDate(announcement.date),
    });
  }
}
