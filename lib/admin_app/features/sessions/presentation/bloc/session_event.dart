import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

class AddSessionButtonPressed extends SessionEvent {
  final String name;
  final DateTime date;
  final File coverImage;
  final List<File> galleryImages;
  const AddSessionButtonPressed({
    required this.name,
    required this.date,
    required this.coverImage,
    required this.galleryImages,
  });
}

class UpdateSessionButtonPressed extends SessionEvent {
  final SessionEntity session;
  final File? newCoverImage;
  final List<File>? newGalleryImages;
  const UpdateSessionButtonPressed({
    required this.session,
    this.newCoverImage,
    this.newGalleryImages,
  });
}

class DeleteSessionButtonPressed extends SessionEvent {
  final SessionEntity session;
  const DeleteSessionButtonPressed({required this.session});
}

class LoadSessions extends SessionEvent {}
