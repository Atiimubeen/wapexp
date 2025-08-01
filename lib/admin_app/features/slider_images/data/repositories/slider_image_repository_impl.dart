import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/core/network/network_info.dart';
import 'package:wapexp/admin_app/features/slider_images/data/datasources/slider_image_remote_data_source.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/entities/slider_image_entity.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/repositories/slider_image_repository.dart';

class SliderImageRepositoryImpl implements SliderImageRepository {
  final SliderImageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SliderImageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> addSliderImage(File image) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addSliderImage(image);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to add image.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Stream<Either<Failure, List<SliderImageEntity>>> getSliderImages() async* {
    if (await networkInfo.isConnected) {
      try {
        await for (final images in remoteDataSource.getSliderImages()) {
          yield Right(images);
        }
      } catch (e) {
        yield Left(ServerFailure(message: 'Failed to fetch images.'));
      }
    } else {
      yield Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSliderImage(
    SliderImageEntity image,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteSliderImage(image);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to delete image.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
