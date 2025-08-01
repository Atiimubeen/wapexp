import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/sessions/domain/repositories/session_repository.dart';

class AddSessionUseCase {
  final SessionRepository repository;
  AddSessionUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  }) {
    return repository.addSession(
      name: name,
      date: date,
      coverImage: coverImage,
      galleryImages: galleryImages,
    );
  }
}
