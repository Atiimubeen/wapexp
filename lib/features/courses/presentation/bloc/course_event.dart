import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:wapexp/features/courses/domain/entities/course_entity.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
  @override
  List<Object?> get props => [];
}

// Event jab course add karna ho
class AddCourseButtonPressed extends CourseEvent {
  final String name;
  final String description;
  final String price;
  final String? discountedPrice;
  final String duration;
  final File image;
  final String? startDate;
  final String? endDate;
  final String? offerEndDate;

  const AddCourseButtonPressed({
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.duration,
    required this.image,
    this.startDate,
    this.endDate,
    this.offerEndDate,
  });
}

// Event jab course update karna ho
class UpdateCourseButtonPressed extends CourseEvent {
  final CourseEntity course;
  // TODO: Add support for updating image
  const UpdateCourseButtonPressed({required this.course});
  @override
  List<Object?> get props => [course];
}

// Event jab course delete karna ho
class DeleteCourseButtonPressed extends CourseEvent {
  final String courseId;
  final String imageUrl;
  const DeleteCourseButtonPressed({
    required this.courseId,
    required this.imageUrl,
  });
  @override
  List<Object?> get props => [courseId, imageUrl];
}

// Event jab courses ki list load karni ho
class LoadCourses extends CourseEvent {}
