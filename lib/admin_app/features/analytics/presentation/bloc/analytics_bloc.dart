import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/analytics/domain/usecases/get_analytics_data_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalyticsDataUseCase _getAnalyticsDataUseCase;

  AnalyticsBloc({required GetAnalyticsDataUseCase getAnalyticsDataUseCase})
    : _getAnalyticsDataUseCase = getAnalyticsDataUseCase,
      super(AnalyticsInitial()) {
    on<LoadAnalyticsData>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadAnalyticsData event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final result = await _getAnalyticsDataUseCase();
    result.fold(
      (failure) => emit(AnalyticsFailure(message: failure.message)),
      (data) => emit(AnalyticsLoaded(data: data)),
    );
  }
}
