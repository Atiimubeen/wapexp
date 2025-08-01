import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wapexp/features/slider_images/domain/entities/slider_image_entity.dart';

class SliderImageModel extends SliderImageEntity {
  const SliderImageModel({required super.id, required super.imageUrl});

  factory SliderImageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SliderImageModel(id: doc.id, imageUrl: data['imageUrl'] ?? '');
  }
}
