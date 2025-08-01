import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/add_slider_image_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/delete_slider_image_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/get_slider_images_usecase.dart';
import 'slider_image_event.dart';
import 'slider_image_state.dart';

class SliderImageBloc extends Bloc<SliderImageEvent, SliderImageState> {
  final AddSliderImageUseCase _addUseCase;
  final GetSliderImagesUseCase _getUseCase;
  final DeleteSliderImageUseCase _deleteUseCase;

  SliderImageBloc({
    required AddSliderImageUseCase addUseCase,
    required GetSliderImagesUseCase getUseCase,
    required DeleteSliderImageUseCase deleteUseCase,
  }) : _addUseCase = addUseCase,
       _getUseCase = getUseCase,
       _deleteUseCase = deleteUseCase,
       super(SliderImageInitial()) {
    on<AddSliderImage>(_onAdd);
    on<LoadSliderImages>(_onLoad);
    on<DeleteSliderImage>(_onDelete);
  }

  Future<void> _onAdd(
    AddSliderImage event,
    Emitter<SliderImageState> emit,
  ) async {
    emit(SliderImageLoading());
    final result = await _addUseCase(event.image);
    result.fold(
      (failure) => emit(SliderImageFailure(message: failure.message)),
      (_) => emit(const SliderImageActionSuccess(message: 'Image Added!')),
    );
  }

  Future<void> _onLoad(
    LoadSliderImages event,
    Emitter<SliderImageState> emit,
  ) async {
    emit(SliderImageLoading());
    await emit.forEach(
      _getUseCase(),
      onData: (result) => result.fold(
        (failure) => SliderImageFailure(message: failure.message),
        (images) => SliderImagesLoaded(images: images),
      ),
    );
  }

  Future<void> _onDelete(
    DeleteSliderImage event,
    Emitter<SliderImageState> emit,
  ) async {
    final result = await _deleteUseCase(event.image);
    result.fold(
      (failure) => emit(SliderImageFailure(message: failure.message)),
      (_) => emit(const SliderImageActionSuccess(message: 'Image Deleted!')),
    );
  }
}
