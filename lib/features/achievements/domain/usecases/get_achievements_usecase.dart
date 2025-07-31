import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/achievements/domain/entities/achievement_entity.dart';
import 'package:wapexp/features/achievements/domain/repositories/achievement_repository.dart';

class GetAchievementsUseCase {
  final AchievementRepository repository;
  GetAchievementsUseCase({required this.repository});
  Stream<Either<Failure, List<AchievementEntity>>> call() =>
      repository.getAchievements();
}
