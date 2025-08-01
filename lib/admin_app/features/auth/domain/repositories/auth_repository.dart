import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signUp({
    required String name,
    required String email,
    required String password,
    required File? image,
  });

  Future<Either<Failure, void>> logIn({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Stream<UserEntity?> get user;
}
