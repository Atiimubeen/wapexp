import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/get_achievements_usecase.dart';
import 'user_achievements_event.dart';
import 'user_achievements_state.dart';

class UserAchievementsBloc
    extends Bloc<UserAchievementsEvent, UserAchievementsState> {
  final GetAchievementsUseCase _getAchievementsUseCase;

  UserAchievementsBloc({required GetAchievementsUseCase getAchievementsUseCase})
    : _getAchievementsUseCase = getAchievementsUseCase,
      super(UserAchievementsInitial()) {
    on<LoadUserAchievements>(_onLoadAchievements);
  }

  Future<void> _onLoadAchievements(
    LoadUserAchievements event,
    Emitter<UserAchievementsState> emit,
  ) async {
    emit(UserAchievementsLoading());
    await emit.forEach(
      _getAchievementsUseCase(),
      onData: (result) => result.fold(
        (failure) => UserAchievementsFailure(message: failure.message),
        (achievements) => UserAchievementsLoaded(achievements: achievements),
      ),
      onError: (error, stackTrace) =>
          const UserAchievementsFailure(message: 'An error occurred.'),
    );
  }
}
