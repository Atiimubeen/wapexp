import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/analytics/domain/entities/analytics_data_entity.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsDataEntity>> getAnalyticsData();
}
