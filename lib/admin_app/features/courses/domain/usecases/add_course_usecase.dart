import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/courses/domain/repositories/course_repository.dart';

class AddCourseUseCase {
  final CourseRepository repository;

  AddCourseUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String name,
    required String description,
    required String price,
    String? discountedPrice,
    required String duration,
    required File image,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? offerEndDate,
  }) {
    return repository.addCourse(
      name: name,
      description: description,
      price: price,
      discountedPrice: discountedPrice,
      duration: duration,
      image: image,
      startDate: startDate,
      endDate: endDate,
      offerEndDate: offerEndDate,
    );
  }
}
