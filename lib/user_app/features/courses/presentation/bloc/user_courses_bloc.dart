import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/get_courses_usecase.dart';
import 'user_courses_event.dart';
import 'user_courses_state.dart';
import 'package:wapexp/admin_app/features/courses/domain/usecases/increment_view_count_usecase.dart';

class UserCoursesBloc extends Bloc<UserCoursesEvent, UserCoursesState> {
  final GetCoursesUseCase _getCoursesUseCase;
  final IncrementViewCountUseCase _incrementViewCountUseCase;
  UserCoursesBloc({
    required GetCoursesUseCase getCoursesUseCase,
    required IncrementViewCountUseCase
    incrementViewCountUseCase, // <-- Naya use case
  }) : _getCoursesUseCase = getCoursesUseCase,
       _incrementViewCountUseCase = incrementViewCountUseCase,
       super(UserCoursesInitial()) {
    on<LoadUserCourses>(_onLoadCourses);
    on<CourseCardTapped>(_onCourseCardTapped); // <-- Naya event handler
  }
  Future<void> _onCourseCardTapped(
    CourseCardTapped event,
    Emitter<UserCoursesState> emit,
  ) async {
    // Is event par UI state change nahi karni, sirf background mein kaam karna hai
    await _incrementViewCountUseCase(event.courseId);
  }

  Future<void> _onLoadCourses(
    LoadUserCourses event,
    Emitter<UserCoursesState> emit,
  ) async {
    emit(UserCoursesLoading());
    await emit.forEach(
      _getCoursesUseCase(),
      onData: (result) => result.fold(
        (failure) => UserCoursesFailure(message: failure.message),
        (courses) => UserCoursesLoaded(courses: courses),
      ),
      onError: (error, stackTrace) =>
          const UserCoursesFailure(message: 'An error occurred.'),
    );
  }
}
