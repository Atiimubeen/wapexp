import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/courses/domain/entities/course_entity.dart';

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

  // **NAYA FUNCTION**
  // Yeh function Firebase se courses ki real-time stream haasil karega.
  Stream<Either<Failure, List<CourseEntity>>> getCourses();
  Future<Either<Failure, void>> updateCourse(CourseEntity course);
  Future<Either<Failure, void>> deleteCourse(String courseId, String imageUrl);
}
