import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/sessions/domain/entities/session_entity.dart';

abstract class SessionRepository {
  Future<Either<Failure, void>> addSession({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  });
  Stream<Either<Failure, List<SessionEntity>>> getSessions();
  Future<Either<Failure, void>> deleteSession(SessionEntity session);
  Future<Either<Failure, void>> updateSession(SessionEntity session);
}
