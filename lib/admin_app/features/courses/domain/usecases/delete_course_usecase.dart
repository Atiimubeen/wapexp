import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/courses/domain/repositories/course_repository.dart';

class DeleteCourseUseCase {
  final CourseRepository repository;
  DeleteCourseUseCase({required this.repository});

  Future<Either<Failure, void>> call(String courseId, String imageUrl) {
    return repository.deleteCourse(courseId, imageUrl);
  }
}
