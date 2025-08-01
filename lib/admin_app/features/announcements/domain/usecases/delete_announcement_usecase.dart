import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/announcements/domain/repositories/announcement_repository.dart';

class DeleteAnnouncementUseCase {
  final AnnouncementRepository repository;
  DeleteAnnouncementUseCase({required this.repository});
  Future<Either<Failure, void>> call(String id) =>
      repository.deleteAnnouncement(id);
}
