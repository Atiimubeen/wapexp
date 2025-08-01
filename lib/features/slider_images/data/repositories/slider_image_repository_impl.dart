import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/slider_images/data/datasources/slider_image_remote_data_source.dart';
import 'package:wapexp/features/slider_images/domain/entities/slider_image_entity.dart';
import 'package:wapexp/features/slider_images/domain/repositories/slider_image_repository.dart';

class SliderImageRepositoryImpl implements SliderImageRepository {
  final SliderImageRemoteDataSource remoteDataSource;
  SliderImageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addSliderImage(File image) async {
    try {
      await remoteDataSource.addSliderImage(image);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to add image.'));
    }
  }

  @override
  Stream<Either<Failure, List<SliderImageEntity>>> getSliderImages() async* {
    try {
      await for (final images in remoteDataSource.getSliderImages()) {
        yield Right(images);
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Failed to fetch images.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSliderImage(
    SliderImageEntity image,
  ) async {
    try {
      await remoteDataSource.deleteSliderImage(image);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete image.'));
    }
  }
}
