import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/courses/domain/entities/course_entity.dart';
import 'package:wapexp/admin_app/features/courses/domain/repositories/course_repository.dart';

class UpdateCourseUseCase {
  final CourseRepository repository;
  UpdateCourseUseCase({required this.repository});

  Future<Either<Failure, void>> call(CourseEntity course) {
    return repository.updateCourse(course);
  }
}
