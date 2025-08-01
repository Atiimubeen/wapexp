import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/core/network/network_info.dart';
import 'package:wapexp/admin_app/features/achievements/data/datasources/achievement_remote_data_source.dart';
import 'package:wapexp/admin_app/features/achievements/domain/entities/achievement_entity.dart';
import 'package:wapexp/admin_app/features/achievements/domain/repositories/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AchievementRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // Yahan bhi har function mein network check add karein, bilkul CourseRepositoryImpl ki tarah

  @override
  Future<Either<Failure, void>> addAchievement({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addAchievement(
          name: name,
          date: date,
          coverImage: coverImage,
          galleryImages: galleryImages,
        );
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to add achievement.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Stream<Either<Failure, List<AchievementEntity>>> getAchievements() async* {
    if (await networkInfo.isConnected) {
      try {
        await for (final achievements in remoteDataSource.getAchievements()) {
          yield Right(achievements);
        }
      } catch (e) {
        yield Left(ServerFailure(message: 'Failed to fetch achievements.'));
      }
    } else {
      yield Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAchievement(
    AchievementEntity achievement,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAchievement(achievement);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to delete achievement.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAchievement(
    AchievementEntity achievement,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateAchievement(achievement);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to update achievement.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
