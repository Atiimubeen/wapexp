import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/achievements/domain/entities/achievement_entity.dart';

abstract class AchievementState extends Equatable {
  const AchievementState();
  @override
  List<Object> get props => [];
}

class AchievementInitial extends AchievementState {}

class AchievementLoading extends AchievementState {}

class AchievementActionSuccess extends AchievementState {
  final String message;
  const AchievementActionSuccess({required this.message});
}

class AchievementsLoaded extends AchievementState {
  final List<AchievementEntity> achievements;
  const AchievementsLoaded({required this.achievements});
}

class AchievementFailure extends AchievementState {
  final String message;
  const AchievementFailure({required this.message});
}
