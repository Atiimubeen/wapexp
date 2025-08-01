import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/core/network/network_info.dart';
import 'package:wapexp/admin_app/features/auth/domain/entities/user_entity.dart';
import 'package:wapexp/admin_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wapexp/admin_app/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> signUp({
    required String name,
    required String email,
    required String password,
    required File? image,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signUp(
          name: name,
          email: email,
          password: password,
          image: image,
        );
        return const Right(null);
      } on FirebaseAuthException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'Signup failed'));
      } catch (e) {
        return Left(ServerFailure(message: 'An unknown error occurred.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logIn({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logIn(email: email, password: password);
        return const Right(null);
      } on FirebaseAuthException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'Login failed'));
      } catch (e) {
        return Left(ServerFailure(message: 'An unknown error occurred.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<void> logOut() async {
    await remoteDataSource.logOut();
  }

  @override
  Stream<UserEntity?> get user => remoteDataSource.user;
}
