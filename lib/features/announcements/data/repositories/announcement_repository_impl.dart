import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/announcements/data/datasources/announcement_remote_data_source.dart';
import 'package:wapexp/features/announcements/domain/entities/announcement_entity.dart';
import 'package:wapexp/features/announcements/domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;
  AnnouncementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addAnnouncement({
    required String title,
    required String description,
  }) async {
    try {
      await remoteDataSource.addAnnouncement(
        title: title,
        description: description,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to add announcement.'));
    }
  }

  @override
  Stream<Either<Failure, List<AnnouncementEntity>>> getAnnouncements() async* {
    try {
      await for (final announcements in remoteDataSource.getAnnouncements()) {
        yield Right(announcements);
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Failed to fetch announcements.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnnouncement(String id) async {
    try {
      await remoteDataSource.deleteAnnouncement(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete announcement.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAnnouncement(
    AnnouncementEntity announcement,
  ) async {
    try {
      await remoteDataSource.updateAnnouncement(announcement);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update announcement.'));
    }
  }
}
