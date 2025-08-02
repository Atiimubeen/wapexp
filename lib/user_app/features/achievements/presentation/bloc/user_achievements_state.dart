import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/achievements/domain/entities/achievement_entity.dart';

abstract class UserAchievementsState extends Equatable {
  const UserAchievementsState();
  @override
  List<Object> get props => [];
}

class UserAchievementsInitial extends UserAchievementsState {}

class UserAchievementsLoading extends UserAchievementsState {}

class UserAchievementsLoaded extends UserAchievementsState {
  final List<AchievementEntity> achievements;
  const UserAchievementsLoaded({required this.achievements});
  @override
  List<Object> get props => [achievements];
}

class UserAchievementsFailure extends UserAchievementsState {
  final String message;
  const UserAchievementsFailure({required this.message});
}
