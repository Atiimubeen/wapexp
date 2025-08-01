import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/repositories/slider_image_repository.dart';

class AddSliderImageUseCase {
  final SliderImageRepository repository;
  AddSliderImageUseCase({required this.repository});
  Future<Either<Failure, void>> call(File image) =>
      repository.addSliderImage(image);
}
