import 'package:get_it/get_it.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/get_achievements_usecase.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/increment_view_count_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/get_slider_images_usecase.dart';
import 'package:wapexp/user_app/features/achievements/presentation/bloc/user_achievements_bloc.dart';
import 'package:wapexp/user_app/features/courses/presentation/bloc/user_courses_bloc.dart';
import 'package:wapexp/user_app/features/home/presentation/bloc/home_bloc.dart';

// Hum wahi 'getIt' instance istemal kar rahe hain
final getIt = GetIt.instance;

Future<void> setupUserDependencies() async {
  // ================= BLoCs =================
  // HomeBloc ko register karna
  getIt.registerFactory(
    () => HomeBloc(getSliderImagesUseCase: getIt<GetSliderImagesUseCase>()),
  );
  getIt.registerFactory(
    () => UserCoursesBloc(
      getCoursesUseCase: getIt<GetCoursesUseCase>(),
      incrementViewCountUseCase: getIt<IncrementViewCountUseCase>(),
    ),
  );
  // **NAYI REGISTRATION**
  getIt.registerFactory(
    () => UserAchievementsBloc(
      getAchievementsUseCase: getIt<GetAchievementsUseCase>(),
    ),
  );
}
