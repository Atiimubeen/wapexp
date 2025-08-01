import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/sessions/data/datasources/session_remote_data_source.dart';
import 'package:wapexp/features/sessions/domain/entities/session_entity.dart';
import 'package:wapexp/features/sessions/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;
  SessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addSession({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  }) async {
    try {
      await remoteDataSource.addSession(
        name: name,
        date: date,
        coverImage: coverImage,
        galleryImages: galleryImages,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to add session.'));
    }
  }

  @override
  Stream<Either<Failure, List<SessionEntity>>> getSessions() async* {
    try {
      await for (final sessions in remoteDataSource.getSessions()) {
        yield Right(sessions);
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Failed to fetch sessions.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(SessionEntity session) async {
    try {
      await remoteDataSource.deleteSession(session);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete session.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSession(SessionEntity session) async {
    try {
      await remoteDataSource.updateSession(session);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update session.'));
    }
  }
}
