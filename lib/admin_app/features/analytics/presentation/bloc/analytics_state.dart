import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/analytics/domain/entities/analytics_data_entity.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();
  @override
  List<Object> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsDataEntity data;
  const AnalyticsLoaded({required this.data});
  @override
  List<Object> get props => [data];
}

class AnalyticsFailure extends AnalyticsState {
  final String message;
  const AnalyticsFailure({required this.message});
}
