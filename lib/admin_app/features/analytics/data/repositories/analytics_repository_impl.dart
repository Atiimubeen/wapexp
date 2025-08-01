import 'package:dartz/dartz.dart';
import 'package:wapexp/core/error/failure.dart';
import 'package:wapexp/core/network/network_info.dart';
import 'package:wapexp/admin_app/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:wapexp/admin_app/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:wapexp/admin_app/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AnalyticsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AnalyticsDataEntity>> getAnalyticsData() async {
    if (await networkInfo.isConnected) {
      try {
        final totalUsers = await remoteDataSource.getTotalUserCount();
        final topCourses = await remoteDataSource.getTopViewedCourses();
        return Right(
          AnalyticsDataEntity(totalUsers: totalUsers, topCourses: topCourses),
        );
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to fetch analytics data.'));
      }
    } else {
      return Left(ServerFailure(message: 'No Internet Connection'));
    }
  }
}
