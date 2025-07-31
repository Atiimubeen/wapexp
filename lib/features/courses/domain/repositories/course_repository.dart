import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
//import 'package:wapexp/features/courses/domain/entities/course_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, void>> addCourse({
    required String name,
    required String description,
    required String price,
    String? discountedPrice,
    required String duration,
    required File image,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? offerEndDate,
  });

  // TODO: Add other methods like getCourses, updateCourse, deleteCourse
}
