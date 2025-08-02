import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/courses/domain/entities/course_entity.dart';

abstract class UserCoursesState extends Equatable {
  const UserCoursesState();
  @override
  List<Object> get props => [];
}

class UserCoursesInitial extends UserCoursesState {}

class UserCoursesLoading extends UserCoursesState {}

class UserCoursesLoaded extends UserCoursesState {
  final List<CourseEntity> courses;
  const UserCoursesLoaded({required this.courses});
  @override
  List<Object> get props => [courses];
}

class UserCoursesFailure extends UserCoursesState {
  final String message;
  const UserCoursesFailure({required this.message});
}
