import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/announcements/domain/entities/announcement_entity.dart';
import 'package:wapexp/features/announcements/domain/repositories/announcement_repository.dart';

class GetAnnouncementsUseCase {
  final AnnouncementRepository repository;
  GetAnnouncementsUseCase({required this.repository});
  Stream<Either<Failure, List<AnnouncementEntity>>> call() =>
      repository.getAnnouncements();
}
