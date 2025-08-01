import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/add_achievement_usecase.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/delete_achievement_usecase.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/get_achievements_usecase.dart';
import 'package:wapexp/admin_app/features/achievements/domain/usecases/update_achievement_usecase.dart';
import 'achievement_event.dart';
import 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final AddAchievementUseCase _addAchievementUseCase;
  final GetAchievementsUseCase _getAchievementsUseCase;
  final DeleteAchievementUseCase _deleteAchievementUseCase;
  final UpdateAchievementUseCase _updateAchievementUseCase;

  AchievementBloc({
    required AddAchievementUseCase addAchievementUseCase,
    required GetAchievementsUseCase getAchievementsUseCase,
    required DeleteAchievementUseCase deleteAchievementUseCase,
    required UpdateAchievementUseCase updateAchievementUseCase,
  }) : _addAchievementUseCase = addAchievementUseCase,
       _getAchievementsUseCase = getAchievementsUseCase,
       _deleteAchievementUseCase = deleteAchievementUseCase,
       _updateAchievementUseCase = updateAchievementUseCase,
       super(AchievementInitial()) {
    on<AddAchievementButtonPressed>(_onAdd);
    on<LoadAchievements>(_onLoad);
    on<DeleteAchievementButtonPressed>(_onDelete);
    on<UpdateAchievementButtonPressed>(_onUpdate);
  }

  Future<void> _onAdd(
    AddAchievementButtonPressed event,
    Emitter<AchievementState> emit,
  ) async {
    emit(AchievementLoading());
    final result = await _addAchievementUseCase(
      name: event.name,
      date: event.date,
      coverImage: event.coverImage,
      galleryImages: event.galleryImages,
    );
    result.fold(
      (failure) => emit(AchievementFailure(message: failure.message)),
      (_) =>
          emit(const AchievementActionSuccess(message: 'Achievement Added!')),
    );
  }

  Future<void> _onLoad(
    LoadAchievements event,
    Emitter<AchievementState> emit,
  ) async {
    emit(AchievementLoading());
    await emit.forEach(
      _getAchievementsUseCase(),
      onData: (result) => result.fold(
        (failure) => AchievementFailure(message: failure.message),
        (achievements) => AchievementsLoaded(achievements: achievements),
      ),
    );
  }

  Future<void> _onDelete(
    DeleteAchievementButtonPressed event,
    Emitter<AchievementState> emit,
  ) async {
    final result = await _deleteAchievementUseCase(event.achievement);
    result.fold(
      (failure) => emit(AchievementFailure(message: failure.message)),
      (_) =>
          emit(const AchievementActionSuccess(message: 'Achievement Deleted!')),
    );
  }

  Future<void> _onUpdate(
    UpdateAchievementButtonPressed event,
    Emitter<AchievementState> emit,
  ) async {
    emit(AchievementLoading());
    final result = await _updateAchievementUseCase(event.achievement);
    result.fold(
      (failure) => emit(AchievementFailure(message: failure.message)),
      (_) =>
          emit(const AchievementActionSuccess(message: 'Achievement Updated!')),
    );
  }
}
