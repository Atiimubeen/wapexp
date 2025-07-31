import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/courses/domain/entities/course_entity.dart';
import 'package:wapexp/features/courses/domain/repositories/course_repository.dart';

class GetCoursesUseCase {
  final CourseRepository repository;

  GetCoursesUseCase({required this.repository});

  Stream<Either<Failure, List<CourseEntity>>> call() {
    return repository.getCourses();
  }
}
