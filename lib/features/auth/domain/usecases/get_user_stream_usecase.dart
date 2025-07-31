import 'package:wapexp/features/auth/domain/entities/user_entity.dart';
import 'package:wapexp/features/auth/domain/repositories/auth_repository.dart';

class GetUserStreamUseCase {
  final AuthRepository repository;

  GetUserStreamUseCase({required this.repository});

  Stream<UserEntity?> call() {
    return repository.user;
  }
}
