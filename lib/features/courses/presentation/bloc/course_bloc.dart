import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/courses/domain/usecases/add_course_usecase.dart';
import 'package:wapexp/features/courses/domain/usecases/delete_course_usecase.dart';
import 'package:wapexp/features/courses/domain/usecases/get_courses_usecase.dart';
import 'package:wapexp/features/courses/domain/usecases/update_course_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final AddCourseUseCase _addCourseUseCase;
  final GetCoursesUseCase _getCoursesUseCase;
  final DeleteCourseUseCase _deleteCourseUseCase;
  final UpdateCourseUseCase _updateCourseUseCase;

  CourseBloc({
    required AddCourseUseCase addCourseUseCase,
    required GetCoursesUseCase getCoursesUseCase,
    required DeleteCourseUseCase deleteCourseUseCase,
    required UpdateCourseUseCase updateCourseUseCase,
  }) : _addCourseUseCase = addCourseUseCase,
       _getCoursesUseCase = getCoursesUseCase,
       _deleteCourseUseCase = deleteCourseUseCase,
       _updateCourseUseCase = updateCourseUseCase,
       super(CourseInitial()) {
    on<AddCourseButtonPressed>(_onAddCourseButtonPressed);
    on<LoadCourses>(_onLoadCourses);
    on<DeleteCourseButtonPressed>(_onDeleteCourseButtonPressed);
    on<UpdateCourseButtonPressed>(_onUpdateCourseButtonPressed);
  }

  Future<void> _onAddCourseButtonPressed(
    AddCourseButtonPressed event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    DateTime? parseDate(String? dateStr) =>
        dateStr != null && dateStr.isNotEmpty ? DateTime.parse(dateStr) : null;

    final result = await _addCourseUseCase(
      name: event.name,
      description: event.description,
      price: event.price,
      discountedPrice: event.discountedPrice,
      duration: event.duration,
      image: event.image,
      startDate: parseDate(event.startDate),
      endDate: parseDate(event.endDate),
      offerEndDate: parseDate(event.offerEndDate),
    );
    result.fold(
      (failure) => emit(CourseFailure(message: failure.message)),
      // **THE FIX IS HERE:** Hum ab 'CourseActionSuccess' istemal kar rahe hain
      (_) => emit(
        const CourseActionSuccess(message: 'Course Added Successfully!'),
      ),
    );
  }

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    await emit.forEach(
      _getCoursesUseCase(),
      onData: (result) => result.fold(
        (failure) => CourseFailure(message: failure.message),
        (courses) => CoursesLoaded(courses: courses),
      ),
      onError: (error, stackTrace) => const CourseFailure(
        message: 'An error occurred while fetching courses.',
      ),
    );
  }

  Future<void> _onDeleteCourseButtonPressed(
    DeleteCourseButtonPressed event,
    Emitter<CourseState> emit,
  ) async {
    final result = await _deleteCourseUseCase(event.courseId, event.imageUrl);
    result.fold(
      (failure) => emit(CourseFailure(message: failure.message)),
      (_) => emit(const CourseActionSuccess(message: 'Course Deleted!')),
    );
  }

  Future<void> _onUpdateCourseButtonPressed(
    UpdateCourseButtonPressed event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    final result = await _updateCourseUseCase(event.course);
    result.fold(
      (failure) => emit(CourseFailure(message: failure.message)),
      (_) => emit(
        const CourseActionSuccess(message: 'Course Updated Successfully!'),
      ),
    );
  }
}
