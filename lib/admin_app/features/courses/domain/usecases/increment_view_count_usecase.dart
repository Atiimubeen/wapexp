import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/courses/domain/repositories/course_repository.dart';

class IncrementViewCountUseCase {
  final CourseRepository repository;
  IncrementViewCountUseCase({required this.repository});

  Future<Either<Failure, void>> call(String courseId) {
    return repository.incrementViewCount(courseId);
  }
}
