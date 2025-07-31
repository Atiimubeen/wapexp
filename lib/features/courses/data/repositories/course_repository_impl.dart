import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:wapexp/features/courses/domain/entities/course_entity.dart';
import 'package:wapexp/features/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl({required this.remoteDataSource});

  @override
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
  }) async {
    try {
      await remoteDataSource.addCourse(
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
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to add course. Please try again.'),
      );
    }
  }

  @override
  Stream<Either<Failure, List<CourseEntity>>> getCourses() async* {
    try {
      await for (final courses in remoteDataSource.getCourses()) {
        yield Right(courses);
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Failed to fetch courses.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourse(
    String courseId,
    String imageUrl,
  ) async {
    try {
      await remoteDataSource.deleteCourse(courseId, imageUrl);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete course.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCourse(CourseEntity course) async {
    try {
      await remoteDataSource.updateCourse(course);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update course.'));
    }
  }
}
