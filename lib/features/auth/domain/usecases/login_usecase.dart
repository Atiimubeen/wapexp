import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/auth/domain/repositories/auth_repository.dart';

class LogInUseCase {
  final AuthRepository repository;

  LogInUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) async {
    return await repository.logIn(email: email, password: password);
  }
}
