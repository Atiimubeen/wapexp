import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/core/network/network_info.dart';
import 'package:wapexp/admin_app/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:wapexp/admin_app/features/courses/domain/entities/course_entity.dart';
import 'package:wapexp/admin_app/features/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  Future<Either<Failure, void>> incrementViewCount(String courseId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.incrementViewCount(courseId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to update view count.'));
      }
    } else {
      // View count update na ho to user ko error dikhane ki zaroorat nahi
      return const Right(null);
    }
  }

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
    if (await networkInfo.isConnected) {
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
        return Left(ServerFailure(message: 'Failed to add course.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Stream<Either<Failure, List<CourseEntity>>> getCourses() async* {
    if (await networkInfo.isConnected) {
      try {
        await for (final courses in remoteDataSource.getCourses()) {
          yield Right(courses);
        }
      } catch (e) {
        yield Left(ServerFailure(message: 'Failed to fetch courses.'));
      }
    } else {
      yield Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourse(
    String courseId,
    String imageUrl,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteCourse(courseId, imageUrl);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to delete course.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCourse({
    required CourseEntity course,
    File? newImage,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateCourse(course: course, newImage: newImage);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to update course.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
