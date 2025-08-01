import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wapexp/admin_app/features/courses/data/models/course_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<int> getTotalUserCount();
  Future<List<CourseModel>> getTopViewedCourses();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final FirebaseFirestore _firestore;
  AnalyticsRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<int> getTotalUserCount() async {
    final snapshot = await _firestore.collection('users').count().get();
    return snapshot.count ?? 0;
  }

  @override
  Future<List<CourseModel>> getTopViewedCourses() async {
    final snapshot = await _firestore
        .collection('courses')
        .orderBy('viewCount', descending: true)
        .limit(5) // Top 5 courses
        .get();
    return snapshot.docs.map((doc) => CourseModel.fromFirestore(doc)).toList();
  }
}
