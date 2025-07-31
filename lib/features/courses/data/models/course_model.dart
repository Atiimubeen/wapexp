import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wapexp/features/courses/domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.discountedPrice,
    required super.duration,
    required super.imageUrl,
    super.startDate,
    super.endDate,
    super.offerEndDate,
  });

  // Firestore se data parhne ke liye
  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? '',
      discountedPrice: data['discountedPrice'],
      duration: data['duration'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      offerEndDate: (data['offerEndDate'] as Timestamp?)?.toDate(),
    );
  }

  // Firestore mein data likhne ke liye
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'duration': duration,
      'imageUrl': imageUrl,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'offerEndDate': offerEndDate != null
          ? Timestamp.fromDate(offerEndDate!)
          : null,
      'createdAt': FieldValue.serverTimestamp(), // Record kab bana
    };
  }
}
