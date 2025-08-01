import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/announcements/domain/repositories/announcement_repository.dart';

class AddAnnouncementUseCase {
  final AnnouncementRepository repository;
  AddAnnouncementUseCase({required this.repository});
  Future<Either<Failure, void>> call({
    required String title,
    required String description,
  }) => repository.addAnnouncement(title: title, description: description);
}
