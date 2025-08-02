import 'package:equatable/equatable.dart';

abstract class UserCoursesEvent extends Equatable {
  const UserCoursesEvent();
  @override
  List<Object> get props => [];
}

class LoadUserCourses extends UserCoursesEvent {}

class CourseCardTapped extends UserCoursesEvent {
  // <-- Naya event
  final String courseId;
  const CourseCardTapped({required this.courseId});
}
