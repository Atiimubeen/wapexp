import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wapexp/core/network/network_info.dart';

// Auth Imports
import 'package:wapexp/admin_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wapexp/admin_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wapexp/admin_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/get_user_stream_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:wapexp/admin_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';

// Courses Imports
import 'package:wapexp/admin_app/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:wapexp/admin_app/features/courses/data/repositories/course_repository_impl.dart';
import 'package:wapexp/admin_app/features/courses/domain/repositories/course_repository.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/add_course_usecase.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/delete_course_usecase.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/update_course_usecase.dart';
import 'package:wapexp/admin_app/features/courses/presentation/bloc/course_bloc.dart';

// Achievements Imports
import 'package:wapexp/admin_app/features/achievements/data/datasources/achievement_remote_data_source.dart';
import 'package:wapexp/admin_app/features/achievements/data/repositories/achievement_repository_impl.dart';
import 'package:wapexp/admin_app/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/add_achievement_usecase.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/delete_achievement_usecase.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/get_achievements_usecase.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/update_achievement_usecase.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/bloc/achievement_bloc.dart';

// Sessions Imports
import 'package:wapexp/admin_app/features/sessions/data/datasources/session_remote_data_source.dart';
import 'package:wapexp/admin_app/features/sessions/data/repositories/session_repository_impl.dart';
import 'package:wapexp/admin_app/features/sessions/domain/repositories/session_repository.dart';
import 'package:wapexp/admin_app/features/sessions/domain/usecases/add_session_usecase.dart';
import 'package:wapexp/admin_app/features/sessions/domain/usecases/delete_session_usecase.dart';
import 'package:wapexp/admin_app/features/sessions/domain/usecases/get_sessions_usecase.dart';
import 'package:wapexp/admin_app/features/sessions/domain/usecases/update_session_usecase.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/bloc/session_bloc.dart';

// Slider Images Imports
import 'package:wapexp/admin_app/features/slider_images/data/datasources/slider_image_remote_data_source.dart';
import 'package:wapexp/admin_app/features/slider_images/data/repositories/slider_image_repository_impl.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/repositories/slider_image_repository.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/add_slider_image_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/delete_slider_image_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/get_slider_images_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/presentation/bloc/slider_image_bloc.dart';

// Announcements Imports
import 'package:wapexp/admin_app/features/announcements/data/datasources/announcement_remote_data_source.dart';
import 'package:wapexp/admin_app/features/announcements/data/repositories/announcement_repository_impl.dart';
import 'package:wapexp/admin_app/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/add_announcement_usecase.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/delete_announcement_usecase.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/get_announcements_usecase.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/update_announcement_usecase.dart';
import 'package:wapexp/admin_app/features/announcements/presentation/bloc/announcement_bloc.dart';

// Analytics Imports
import 'package:wapexp/admin_app/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:wapexp/admin_app/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:wapexp/admin_app/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:wapexp/admin_app/features/analytics/domain/usecases/get_analytics_data_usecase.dart';
import 'package:wapexp/admin_app/features/analytics/presentation/bloc/analytics_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ================= EXTERNAL & CORE =================
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(() => Connectivity());

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
  getIt.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => AnalyticsRemoteDataSourceImpl(firestore: getIt()),
  );

  // ================= REPOSITORIES =================
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton<AchievementRepository>(
    () => AchievementRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<SessionRepository>(
    () =>
        SessionRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton<SliderImageRepository>(
    () => SliderImageRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
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
  // Analytics
  getIt.registerLazySingleton(
    () => GetAnalyticsDataUseCase(repository: getIt()),
  );

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
  getIt.registerFactory(() => AnalyticsBloc(getAnalyticsDataUseCase: getIt()));
}
