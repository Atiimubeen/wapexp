import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/add_announcement_usecase.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/delete_announcement_usecase.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/get_announcements_usecase.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/update_announcement_usecase.dart';
import 'announcement_event.dart';
import 'announcement_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AddAnnouncementUseCase _addUseCase;
  final GetAnnouncementsUseCase _getUseCase;
  final DeleteAnnouncementUseCase _deleteUseCase;
  final UpdateAnnouncementUseCase _updateUseCase;

  AnnouncementBloc({
    required AddAnnouncementUseCase addUseCase,
    required GetAnnouncementsUseCase getUseCase,
    required DeleteAnnouncementUseCase deleteUseCase,
    required UpdateAnnouncementUseCase updateUseCase,
  }) : _addUseCase = addUseCase,
       _getUseCase = getUseCase,
       _deleteUseCase = deleteUseCase,
       _updateUseCase = updateUseCase,
       super(AnnouncementInitial()) {
    on<AddAnnouncementButtonPressed>(_onAdd);
    on<LoadAnnouncements>(_onLoad);
    on<DeleteAnnouncementButtonPressed>(_onDelete);
    on<UpdateAnnouncementButtonPressed>(_onUpdate);
  }

  Future<void> _onAdd(
    AddAnnouncementButtonPressed event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    final result = await _addUseCase(
      title: event.title,
      description: event.description,
    );
    result.fold(
      (failure) => emit(AnnouncementFailure(message: failure.message)),
      (_) =>
          emit(const AnnouncementActionSuccess(message: 'Announcement Added!')),
    );
  }

  Future<void> _onLoad(
    LoadAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    await emit.forEach(
      _getUseCase(),
      onData: (result) => result.fold(
        (failure) => AnnouncementFailure(message: failure.message),
        (announcements) => AnnouncementsLoaded(announcements: announcements),
      ),
    );
  }

  Future<void> _onDelete(
    DeleteAnnouncementButtonPressed event,
    Emitter<AnnouncementState> emit,
  ) async {
    final result = await _deleteUseCase(event.id);
    result.fold(
      (failure) => emit(AnnouncementFailure(message: failure.message)),
      (_) => emit(
        const AnnouncementActionSuccess(message: 'Announcement Deleted!'),
      ),
    );
  }

  Future<void> _onUpdate(
    UpdateAnnouncementButtonPressed event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    final result = await _updateUseCase(event.announcement);
    result.fold(
      (failure) => emit(AnnouncementFailure(message: failure.message)),
      (_) => emit(
        const AnnouncementActionSuccess(message: 'Announcement Updated!'),
      ),
    );
  }
}
