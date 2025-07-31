import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:wapexp/features/achievements/domain/entities/achievement_entity.dart';

abstract class AchievementEvent extends Equatable {
  const AchievementEvent();
  @override
  List<Object?> get props => [];
}

class AddAchievementButtonPressed extends AchievementEvent {
  final String name;
  final DateTime date;
  final File coverImage;
  final List<File> galleryImages;
  const AddAchievementButtonPressed({
    required this.name,
    required this.date,
    required this.coverImage,
    required this.galleryImages,
  });
}

class UpdateAchievementButtonPressed extends AchievementEvent {
  final AchievementEntity achievement;
  const UpdateAchievementButtonPressed({required this.achievement});
}

class DeleteAchievementButtonPressed extends AchievementEvent {
  final AchievementEntity achievement;
  const DeleteAchievementButtonPressed({required this.achievement});
}

class LoadAchievements extends AchievementEvent {}
