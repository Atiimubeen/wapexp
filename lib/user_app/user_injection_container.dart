import 'package:get_it/get_it.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/get_achievements_usecase.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/get_announcements_usecase.dart'; // <-- Naya import
import 'package:wapexp/admin_app/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/increment_view_count_usecase.dart';
import 'package:wapexp/admin_app/features/sessions/domain/usecases/get_sessions_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/get_slider_images_usecase.dart';
import 'package:wapexp/user_app/features/achievements/presentation/bloc/user_achievements_bloc.dart';
import 'package:wapexp/user_app/features/courses/presentation/bloc/user_courses_bloc.dart';
import 'package:wapexp/user_app/features/sessions/presentation/bloc/user_sessions_bloc.dart';
import 'package:wapexp/user_app/presentation/bloc/home_bloc.dart'; // Sahi path

final getIt = GetIt.instance;

Future<void> setupUserDependencies() async {
  // ================= BLoCs =================
  getIt.registerFactory(
    () => HomeBloc(
      getSliderImagesUseCase: getIt<GetSliderImagesUseCase>(),
      getAnnouncementsUseCase:
          getIt<GetAnnouncementsUseCase>(), // <-- Naya use case
    ),
  );
  getIt.registerFactory(
    () => UserCoursesBloc(
      getCoursesUseCase: getIt<GetCoursesUseCase>(),
      incrementViewCountUseCase: getIt<IncrementViewCountUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => UserAchievementsBloc(
      getAchievementsUseCase: getIt<GetAchievementsUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => UserSessionsBloc(getSessionsUseCase: getIt<GetSessionsUseCase>()),
  );
}
