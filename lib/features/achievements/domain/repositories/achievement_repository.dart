import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/achievements/domain/entities/achievement_entity.dart';

abstract class AchievementRepository {
  Future<Either<Failure, void>> addAchievement({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  });
  Stream<Either<Failure, List<AchievementEntity>>> getAchievements();
  Future<Either<Failure, void>> deleteAchievement(
    AchievementEntity achievement,
  );
  // Update ke liye abhi hum sirf text update kar rahe hain, image nahi.
  Future<Either<Failure, void>> updateAchievement(
    AchievementEntity achievement,
  );
}
