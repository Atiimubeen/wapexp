import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/core/network/network_info.dart';
import 'package:wapexp/admin_app/features/sessions/data/datasources/session_remote_data_source.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';
import 'package:wapexp/admin_app/features/sessions/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SessionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // Yahan bhi har function mein network check add karein

  @override
  Future<Either<Failure, void>> addSession({
    required String name,
    required DateTime date,
    required File coverImage,
    required List<File> galleryImages,
  }) async {
    if (await networkInfo.isConnected) {
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
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Stream<Either<Failure, List<SessionEntity>>> getSessions() async* {
    if (await networkInfo.isConnected) {
      try {
        await for (final sessions in remoteDataSource.getSessions()) {
          yield Right(sessions);
        }
      } catch (e) {
        yield Left(ServerFailure(message: 'Failed to fetch sessions.'));
      }
    } else {
      yield Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(SessionEntity session) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteSession(session);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to delete session.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSession(SessionEntity session) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateSession(session);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to update session.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
