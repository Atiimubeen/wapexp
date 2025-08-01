import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';
import 'package:wapexp/admin_app/features/sessions/domain/repositories/session_repository.dart';

class DeleteSessionUseCase {
  final SessionRepository repository;
  DeleteSessionUseCase({required this.repository});
  Future<Either<Failure, void>> call(SessionEntity session) =>
      repository.deleteSession(session);
}
