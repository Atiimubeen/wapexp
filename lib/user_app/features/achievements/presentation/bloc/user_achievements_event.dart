import 'package:equatable/equatable.dart';

abstract class UserAchievementsEvent extends Equatable {
  const UserAchievementsEvent();
  @override
  List<Object> get props => [];
}

class LoadUserAchievements extends UserAchievementsEvent {}
