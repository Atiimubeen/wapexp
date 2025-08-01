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

// Sessions Imports
import 'package:wapexp/features/sessions/data/datasources/session_remote_data_source.dart';
import 'package:wapexp/features/sessions/data/repositories/session_repository_impl.dart';
import 'package:wapexp/features/sessions/domain/repositories/session_repository.dart';
import 'package:wapexp/features/sessions/domain/usecases/add_session_usecase.dart';
import 'package:wapexp/features/sessions/domain/usecases/delete_session_usecase.dart';
import 'package:wapexp/features/sessions/domain/usecases/get_sessions_usecase.dart';
import 'package:wapexp/features/sessions/domain/usecases/update_session_usecase.dart';
import 'package:wapexp/features/sessions/presentation/bloc/session_bloc.dart';

// Slider Images Imports
import 'package:wapexp/features/slider_images/data/datasources/slider_image_remote_data_source.dart';
import 'package:wapexp/features/slider_images/data/repositories/slider_image_repository_impl.dart';
import 'package:wapexp/features/slider_images/domain/repositories/slider_image_repository.dart';
import 'package:wapexp/features/slider_images/domain/usecases/add_slider_image_usecase.dart';
import 'package:wapexp/features/slider_images/domain/usecases/delete_slider_image_usecase.dart';
import 'package:wapexp/features/slider_images/domain/usecases/get_slider_images_usecase.dart';
import 'package:wapexp/features/slider_images/presentation/bloc/slider_image_bloc.dart';

// Announcements Imports
import 'package:wapexp/features/announcements/data/datasources/announcement_remote_data_source.dart';
import 'package:wapexp/features/announcements/data/repositories/announcement_repository_impl.dart';
import 'package:wapexp/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:wapexp/features/announcements/domain/usecases/add_announcement_usecase.dart';
import 'package:wapexp/features/announcements/domain/usecases/delete_announcement_usecase.dart';
import 'package:wapexp/features/announcements/domain/usecases/get_announcements_usecase.dart';
import 'package:wapexp/features/announcements/domain/usecases/update_announcement_usecase.dart';
import 'package:wapexp/features/announcements/presentation/bloc/announcement_bloc.dart';

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
  getIt.registerFactory(
    () => SessionBloc(
      addSessionUseCase: getIt(),
      getSessionsUseCase: getIt(),
      deleteSessionUseCase: getIt(),
      updateSessionUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => SliderImageBloc(
      addUseCase: getIt(),
      getUseCase: getIt(),
      deleteUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => AnnouncementBloc(
      addUseCase: getIt(),
      getUseCase: getIt(),
      deleteUseCase: getIt(),
      updateUseCase: getIt(),
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
  // Sessions
  getIt.registerLazySingleton(() => AddSessionUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => GetSessionsUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => DeleteSessionUseCase(repository: getIt()));
  getIt.registerLazySingleton(() => UpdateSessionUseCase(repository: getIt()));
  // Slider Images
  getIt.registerLazySingleton(() => AddSliderImageUseCase(repository: getIt()));
  getIt.registerLazySingleton(
    () => GetSliderImagesUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteSliderImageUseCase(repository: getIt()),
  );
  // Announcements
  getIt.registerLazySingleton(
    () => AddAnnouncementUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetAnnouncementsUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => DeleteAnnouncementUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => UpdateAnnouncementUseCase(repository: getIt()),
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
  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<SliderImageRepository>(
    () => SliderImageRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(remoteDataSource: getIt()),
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
  getIt.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(firestore: getIt(), storage: getIt()),
  );
  getIt.registerLazySingleton<SliderImageRemoteDataSource>(
    () => SliderImageRemoteDataSourceImpl(firestore: getIt(), storage: getIt()),
  );
  getIt.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(firestore: getIt()),
  );

  // ================= EXTERNAL =================
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
}
