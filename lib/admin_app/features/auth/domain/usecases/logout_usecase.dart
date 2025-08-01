import 'package:wapexp/admin_app/features/auth/domain/repositories/auth_repository.dart';

class LogOutUseCase {
  final AuthRepository repository;

  LogOutUseCase({required this.repository});

  Future<void> call() async {
    return await repository.logOut();
  }
}
