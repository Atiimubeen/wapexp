import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wapexp/admin_app/features/slider_images/data/models/slider_image_model.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/entities/slider_image_entity.dart';

abstract class SliderImageRemoteDataSource {
  Future<void> addSliderImage(File image);
  Stream<List<SliderImageModel>> getSliderImages();
  Future<void> deleteSliderImage(SliderImageEntity image);
}

class SliderImageRemoteDataSourceImpl implements SliderImageRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  SliderImageRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firestore = firestore,
       _storage = storage;

  @override
  Future<void> addSliderImage(File image) async {
    final ref = _storage.ref(
      'slider_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await ref.putFile(image);
    final imageUrl = await ref.getDownloadURL();
    await _firestore.collection('sliderImages').add({
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<SliderImageModel>> getSliderImages() {
    return _firestore
        .collection('sliderImages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SliderImageModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> deleteSliderImage(SliderImageEntity image) async {
    // **THE FIX IS HERE:** Ab yeh Storage se bhi file delete karega.
    // 1. Firestore se document delete karna
    await _firestore.collection('sliderImages').doc(image.id).delete();
    // 2. Storage se image file delete karna
    await _storage.refFromURL(image.imageUrl).delete();
  }
}
