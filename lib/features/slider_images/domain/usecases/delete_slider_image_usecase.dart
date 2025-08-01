import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/slider_images/domain/entities/slider_image_entity.dart';
import 'package:wapexp/features/slider_images/domain/repositories/slider_image_repository.dart';

class DeleteSliderImageUseCase {
  final SliderImageRepository repository;
  DeleteSliderImageUseCase({required this.repository});
  Future<Either<Failure, void>> call(SliderImageEntity image) =>
      repository.deleteSliderImage(image);
}
