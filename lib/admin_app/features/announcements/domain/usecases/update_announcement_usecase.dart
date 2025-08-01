import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/announcements/domain/entities/announcement_entity.dart';
import 'package:wapexp/admin_app/features/announcements/domain/repositories/announcement_repository.dart';

class UpdateAnnouncementUseCase {
  final AnnouncementRepository repository;
  UpdateAnnouncementUseCase({required this.repository});
  Future<Either<Failure, void>> call(AnnouncementEntity announcement) =>
      repository.updateAnnouncement(announcement);
}
