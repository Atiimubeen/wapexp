import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

// Auth Imports
import 'package:wapexp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wapexp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wapexp/features/auth/domain/repositories/auth_repository.dart';
import 'package:wapexp/features/auth/domain/usecases/get_user_stream_usecase.dart';
import 'package:wapexp/features/auth/domain/usecases/login_usecase.dart';
import 'package:wapexp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:wapexp/features/auth/domain/usecases/signup_usecase.dart';
import 'package:wapexp/features/auth/presentation/bloc/auth_bloc.dart';

// Courses Imports
import 'package:wapexp/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:wapexp/features/courses/data/repositories/course_repository_impl.dart';
import 'package:wapexp/features/courses/domain/repositories/course_repository.dart';
import 'package:wapexp/features/courses/domain/usecases/add_course_usecase.dart';
import 'package:wapexp/features/courses/domain/usecases/delete_course_usecase.dart';
import 'package:wapexp/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:wapexp/features/courses/domain/usecases/update_course_usecase.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_bloc.dart';

// Achievements Imports
import 'package:wapexp/features/achievements/data/datasources/achievement_remote_data_source.dart';
import 'package:wapexp/features/achievements/data/repositories/achievement_repository_impl.dart';
import 'package:wapexp/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:wapexp/features/achievements/domain/usecases/add_achievement_usecase.dart';
import 'package:wapexp/features/achievements/domain/usecases/delete_achievement_usecase.dart';
import 'package:wapexp/features/achievements/domain/usecases/get_achievements_usecase.dart';
import 'package:wapexp/features/achievements/domain/usecases/update_achievement_usecase.dart';
import 'package:wapexp/features/achievements/presentation/bloc/achievement_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ================= BLoCs =================
  getIt.registerFactory(
    () => AuthBloc(
      signUpUseCase: getIt(),
      logInUseCase: getIt(),
      logOutUseCase: getIt(),
      getUserStreamUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => CourseBloc(
      addCourseUseCase: getIt(),
      getCoursesUseCase: getIt(),
      deleteCourseUseCase: getIt(),
      updateCourseUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => AchievementBloc(
      addAchievementUseCase: getIt(),
      getAchievementsUseCase: getIt(),
      deleteAchievementUseCase: getIt(),
      updateAchievementUseCase: getIt(),
    ),
  );

  // ================= USE CASES =================
  // Auth
  getIt.registerLazySingleton(() => SignUpUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LogInUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => LogOutUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetUserStreamUseCase(repository: getIt()));
  // Courses
  getIt.registerLazySingleton(() => AddCourseUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetCoursesUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteCourseUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateCourseUseCase(repository: getIt()));
  // Achievements
  getIt.registerLazySingleton(() => AddAchievementUseCase(repository: getIt()));
  getIt.registerLazySingleton(
    () => GetAchievementsUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteAchievementUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateAchievementUseCase(repository: getIt()),
  );

  // ================= REPOSITORIES =================
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<AchievementRepository>(
    () => AchievementRepositoryImpl(remoteDataSource: getIt()),
  );

  // ================= DATA SOURCES =================
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt(),
      firestore: getIt(),
      storage: getIt(),
    ),
  );
  getIt.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(firestore: getIt(), storage: getIt()),
  );
  getIt.registerLazySingleton<AchievementRemoteDataSource>(
    () => AchievementRemoteDataSourceImpl(firestore: getIt(), storage: getIt()),
  );

  // ================= EXTERNAL =================
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
}
