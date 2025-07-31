import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/achievements/data/datasources/achievement_remote_data_source.dart';
import 'package:wapexp/features/achievements/domain/entities/achievement_entity.dart';
import 'package:wapexp/features/achievements/domain/repositories/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementRemoteDataSource remoteDataSource;
  AchievementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addAchievement({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  }) async {
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
  }

  @override
  Stream<Either<Failure, List<AchievementEntity>>> getAchievements() async* {
    try {
      await for (final achievements in remoteDataSource.getAchievements()) {
        yield Right(achievements);
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Failed to fetch achievements.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAchievement(
    AchievementEntity achievement,
  ) async {
    try {
      await remoteDataSource.deleteAchievement(achievement);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete achievement.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAchievement(
    AchievementEntity achievement,
  ) async {
    try {
      await remoteDataSource.updateAchievement(achievement);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update achievement.'));
    }
  }
}
