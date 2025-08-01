import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/sessions/domain/entities/session_entity.dart';
import 'package:wapexp/features/sessions/domain/repositories/session_repository.dart';

class GetSessionsUseCase {
  final SessionRepository repository;
  GetSessionsUseCase({required this.repository});
  Stream<Either<Failure, List<SessionEntity>>> call() =>
      repository.getSessions();
}
