import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/achievements/domain/repositories/achievement_repository.dart';

class AddAchievementUseCase {
  final AchievementRepository repository;
  AddAchievementUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  }) {
    return repository.addAchievement(
      name: name,
      date: date,
      coverImage: coverImage,
      galleryImages: galleryImages,
    );
  }
}
