import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:wapexp/admin_app/features/announcements/domain/entities/announcement_entity.dart';
import 'package:wapexp/admin_app/features/announcements/domain/usecases/get_announcements_usecase.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/entities/slider_image_entity.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/usecases/get_slider_images_usecase.dart';
import 'package:wapexp/core/error/failure.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetSliderImagesUseCase _getSliderImagesUseCase;
  final GetAnnouncementsUseCase _getAnnouncementsUseCase;

  HomeBloc({
    required GetSliderImagesUseCase getSliderImagesUseCase,
    required GetAnnouncementsUseCase getAnnouncementsUseCase,
  }) : _getSliderImagesUseCase = getSliderImagesUseCase,
       _getAnnouncementsUseCase = getAnnouncementsUseCase,
       super(HomeInitial()) {
    on<LoadHomeData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _getSliderImagesUseCase().first,
        _getAnnouncementsUseCase().first,
      ]);

      final sliderResult =
          results[0] as Either<Failure, List<SliderImageEntity>>;
      final announcementResult =
          results[1] as Either<Failure, List<AnnouncementEntity>>;

      if (sliderResult.isLeft()) {
        sliderResult.fold(
          (failure) => emit(HomeFailure(message: failure.message)),
          (_) {},
        );
        return;
      }

      final sliderImages = sliderResult.getOrElse(() => []);
      final announcements = announcementResult.getOrElse(() => []);

      emit(
        HomeLoaded(
          sliderImages: sliderImages,
          latestAnnouncement: announcements.isNotEmpty
              ? announcements.first
              : null,
        ),
      );
    } catch (e) {
      emit(HomeFailure(message: 'An error occurred: ${e.toString()}'));
    }
  }
}
