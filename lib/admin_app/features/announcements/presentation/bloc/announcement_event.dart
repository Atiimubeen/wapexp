import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/announcements/domain/entities/announcement_entity.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();
  @override
  List<Object?> get props => [];
}

class AddAnnouncementButtonPressed extends AnnouncementEvent {
  final String title;
  final String description;
  const AddAnnouncementButtonPressed({
    required this.title,
    required this.description,
  });
}

class UpdateAnnouncementButtonPressed extends AnnouncementEvent {
  final AnnouncementEntity announcement;
  const UpdateAnnouncementButtonPressed({required this.announcement});
}

class DeleteAnnouncementButtonPressed extends AnnouncementEvent {
  final String id;
  const DeleteAnnouncementButtonPressed({required this.id});
}

class LoadAnnouncements extends AnnouncementEvent {}
