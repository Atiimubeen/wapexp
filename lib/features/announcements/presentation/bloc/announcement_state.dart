import 'package:equatable/equatable.dart';
import 'package:wapexp/features/announcements/domain/entities/announcement_entity.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();
  @override
  List<Object> get props => [];
}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementActionSuccess extends AnnouncementState {
  final String message;
  const AnnouncementActionSuccess({required this.message});
}

class AnnouncementsLoaded extends AnnouncementState {
  final List<AnnouncementEntity> announcements;
  const AnnouncementsLoaded({required this.announcements});
}

class AnnouncementFailure extends AnnouncementState {
  final String message;
  const AnnouncementFailure({required this.message});
}
