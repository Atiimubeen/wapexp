import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/core/network/network_info.dart';
import 'package:wapexp/admin_app/features/announcements/data/datasources/announcement_remote_data_source.dart';
import 'package:wapexp/admin_app/features/announcements/domain/entities/announcement_entity.dart';
import 'package:wapexp/admin_app/features/announcements/domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AnnouncementRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> addAnnouncement({
    required String title,
    required String description,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addAnnouncement(
          title: title,
          description: description,
        );
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to add announcement.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Stream<Either<Failure, List<AnnouncementEntity>>> getAnnouncements() async* {
    if (await networkInfo.isConnected) {
      try {
        await for (final announcements in remoteDataSource.getAnnouncements()) {
          yield Right(announcements);
        }
      } catch (e) {
        yield Left(ServerFailure(message: 'Failed to fetch announcements.'));
      }
    } else {
      yield Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnnouncement(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAnnouncement(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to delete announcement.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAnnouncement(
    AnnouncementEntity announcement,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateAnnouncement(announcement);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to update announcement.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
