import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String name,
    required String email,
    required String password,
    required File? image,
  }) async {
    return await repository.signUp(
      name: name,
      email: email,
      password: password,
      image: image,
    );
  }
}
