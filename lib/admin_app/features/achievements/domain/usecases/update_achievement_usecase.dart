import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/achievements/domain/entities/achievement_entity.dart';
import 'package:wapexp/admin_app/features/achievements/domain/repositories/achievement_repository.dart';

class UpdateAchievementUseCase {
  final AchievementRepository repository;
  UpdateAchievementUseCase({required this.repository});
  Future<Either<Failure, void>> call(AchievementEntity achievement) =>
      repository.updateAchievement(achievement);
}
