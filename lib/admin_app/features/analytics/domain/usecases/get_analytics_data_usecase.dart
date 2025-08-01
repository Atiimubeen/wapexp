import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/admin_app/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:wapexp/admin_app/features/analytics/domain/repositories/analytics_repository.dart';

class GetAnalyticsDataUseCase {
  final AnalyticsRepository repository;
  GetAnalyticsDataUseCase({required this.repository});

  Future<Either<Failure, AnalyticsDataEntity>> call() {
    return repository.getAnalyticsData();
  }
}
