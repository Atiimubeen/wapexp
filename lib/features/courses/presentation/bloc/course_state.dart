import 'package:equatable/equatable.dart';

abstract class CourseState extends Equatable {
  const CourseState();
  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseSuccess extends CourseState {}

class CourseFailure extends CourseState {
  final String message;
  const CourseFailure({required this.message});
  @override
  List<Object> get props => [message];
}
