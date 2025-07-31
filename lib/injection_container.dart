import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:wapexp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wapexp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wapexp/features/auth/domain/repositories/auth_repository.dart';
import 'package:wapexp/features/auth/domain/usecases/get_user_stream_usecase.dart';
import 'package:wapexp/features/auth/domain/usecases/login_usecase.dart';
import 'package:wapexp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:wapexp/features/auth/domain/usecases/signup_usecase.dart';
import 'package:wapexp/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ================= BLoCs =================
  // AuthBloc ko register karna. Yeh har baar nayi instance banayega (factory).
  getIt.registerFactory(
    () => AuthBloc(
      signUpUseCase: getIt(),
      logInUseCase: getIt(),
      logOutUseCase: getIt(),
      getUserStreamUseCase: getIt(),
    ),
  );

  // ================= USE CASES =================
  // Tamam use cases ko register karna.
  getIt.registerLazySingleton(() => SignUpUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LogInUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LogOutUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetUserStreamUseCase(repository: getIt()));

  // ================= REPOSITORIES =================
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // ================= DATA SOURCES =================
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt(),
      firestore: getIt(),
      storage: getIt(),
    ),
  );

  // ================= EXTERNAL =================
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
}
