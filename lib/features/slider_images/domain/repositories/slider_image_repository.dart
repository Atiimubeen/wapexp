import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/slider_images/domain/entities/slider_image_entity.dart';

abstract class SliderImageRepository {
  Future<Either<Failure, void>> addSliderImage(File image);
  Stream<Either<Failure, List<SliderImageEntity>>> getSliderImages();
  Future<Either<Failure, void>> deleteSliderImage(SliderImageEntity image);
}
