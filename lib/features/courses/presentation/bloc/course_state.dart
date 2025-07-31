import 'package:equatable/equatable.dart';
import 'package:wapexp/features/courses/domain/entities/course_entity.dart';

abstract class CourseState extends Equatable {
  const CourseState();
  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseActionSuccess extends CourseState {
  final String message;
  const CourseActionSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class CoursesLoaded extends CourseState {
  final List<CourseEntity> courses;
  const CoursesLoaded({required this.courses});
  @override
  List<Object> get props => [courses];
}

class CourseFailure extends CourseState {
  final String message;
  const CourseFailure({required this.message});
  @override
  List<Object> get props => [message];
}
