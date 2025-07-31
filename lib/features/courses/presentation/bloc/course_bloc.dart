import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/courses/domain/usecases/add_course_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final AddCourseUseCase _addCourseUseCase;

  CourseBloc({required AddCourseUseCase addCourseUseCase})
    : _addCourseUseCase = addCourseUseCase,
      super(CourseInitial()) {
    on<AddCourseButtonPressed>(_onAddCourseButtonPressed);
  }

  Future<void> _onAddCourseButtonPressed(
    AddCourseButtonPressed event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());

    // Convert date strings to DateTime objects
    DateTime? parseDate(String? dateStr) {
      return dateStr != null && dateStr.isNotEmpty
          ? DateTime.parse(dateStr)
          : null;
    }

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
      (_) => emit(CourseSuccess()),
    );
  }
}
