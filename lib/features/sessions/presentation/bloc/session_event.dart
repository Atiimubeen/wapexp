import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:wapexp/features/sessions/domain/entities/session_entity.dart';

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
  const UpdateSessionButtonPressed({required this.session});
}

class DeleteSessionButtonPressed extends SessionEvent {
  final SessionEntity session;
  const DeleteSessionButtonPressed({required this.session});
}

class LoadSessions extends SessionEvent {}
