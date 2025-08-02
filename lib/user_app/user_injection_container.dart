import 'package:get_it/get_it.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/get_slider_images_usecase.dart';
import 'package:wapexp/user_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:wapexp/user_app/features/courses/presentation/bloc/user_courses_bloc.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/increment_view_count_usecase.dart';

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
      incrementViewCountUseCase:
          getIt<IncrementViewCountUseCase>(), // <-- Naya use case
    ),
  );
  // NOTE: Repositories aur Use Cases pehle hi 'admin_injection_container' mein
  // register ho chuke hain, is liye humein unhein dobara register karne ki zaroorat nahi.
  // Hum unhein direct istemal kar sakte hain.
}
