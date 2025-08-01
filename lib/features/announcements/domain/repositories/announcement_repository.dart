import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/announcements/domain/entities/announcement_entity.dart';

abstract class AnnouncementRepository {
  Future<Either<Failure, void>> addAnnouncement({
    required String title,
    required String description,
  });
  Stream<Either<Failure, List<AnnouncementEntity>>> getAnnouncements();
  Future<Either<Failure, void>> deleteAnnouncement(String id);
  Future<Either<Failure, void>> updateAnnouncement(
    AnnouncementEntity announcement,
  );
}
