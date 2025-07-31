import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wapexp/features/courses/data/models/course_model.dart';
//import 'package:wapexp/features/courses/data/models/course_model.dart';
import 'package:wapexp/features/courses/domain/entities/course_entity.dart';

abstract class CourseRemoteDataSource {
  Future<void> addCourse({
    required String name,
    required String description,
    required String price,
    String? discountedPrice,
    required String duration,
    required File image,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? offerEndDate,
  });
  Stream<List<CourseModel>> getCourses();
  Future<void> updateCourse(CourseEntity course);
  Future<void> deleteCourse(String courseId, String imageUrl);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CourseRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firestore = firestore,
       _storage = storage;
  @override
  Stream<List<CourseModel>> getCourses() {
    return _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CourseModel.fromFirestore(doc))
              .toList();
        });
  }

  @override
  Future<void> deleteCourse(String courseId, String imageUrl) async {
    // 1. Firestore se document delete karna
    await _firestore.collection('courses').doc(courseId).delete();
    // 2. Storage se image delete karna
    await _storage.refFromURL(imageUrl).delete();
  }

  @override
  Future<void> updateCourse(CourseEntity course) async {
    final courseModel = CourseModel(
      id: course.id,
      name: course.name,
      description: course.description,
      price: course.price,
      discountedPrice: course.discountedPrice,
      duration: course.duration,
      imageUrl: course.imageUrl,
      startDate: course.startDate,
      endDate: course.endDate,
      offerEndDate: course.offerEndDate,
    );

    await _firestore
        .collection('courses')
        .doc(course.id)
        .update(courseModel.toFirestore());
  }

  @override
  Future<void> addCourse({
    required String name,
    required String description,
    required String price,
    String? discountedPrice,
    required String duration,
    required File image,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? offerEndDate,
  }) async {
    // 1. Image ko Firebase Storage par upload karna
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref('course_images').child(imageName);
    await ref.putFile(image);
    final imageUrl = await ref.getDownloadURL();

    // 2. CourseModel ka istemal karke data ko Firestore mein save karna
    final courseData = {
      'name': name,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'duration': duration,
      'imageUrl': imageUrl,
      'startDate': startDate != null ? Timestamp.fromDate(startDate) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
      'offerEndDate': offerEndDate != null
          ? Timestamp.fromDate(offerEndDate)
          : null,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('courses').add(courseData);
  }
}
