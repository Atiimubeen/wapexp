import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/courses/domain/entities/course_entity.dart';

class AnalyticsDataEntity extends Equatable {
  final int totalUsers;
  final List<CourseEntity> topCourses;

  const AnalyticsDataEntity({
    required this.totalUsers,
    required this.topCourses,
  });

  @override
  List<Object?> get props => [totalUsers, topCourses];
}
