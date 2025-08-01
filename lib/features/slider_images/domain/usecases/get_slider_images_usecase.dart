import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/slider_images/domain/entities/slider_image_entity.dart';
import 'package:wapexp/features/slider_images/domain/repositories/slider_image_repository.dart';

class GetSliderImagesUseCase {
  final SliderImageRepository repository;
  GetSliderImagesUseCase({required this.repository});
  Stream<Either<Failure, List<SliderImageEntity>>> call() =>
      repository.getSliderImages();
}
