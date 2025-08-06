// home_bloc.dart (Updated Code)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart'; // rxdart package import karein
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
    // Ab hum _onLoadData ko is tarah register kareinge
    on<LoadHomeData>(
      _onLoadData,
      transformer: (events, mapper) {
        // `switchMap` is liye takay agar user jaldi jaldi refresh kare to purani request cancel ho jaye
        return events.switchMap(mapper);
      },
    );
  }

  Future<void> _onLoadData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    // CombineLatestStream.combine2 ka istemal karke dono streams ko jorein
    // Yeh ek nayi stream banayega jo tab trigger hogi jab bhi images YA announcements mein change aayega
    final combinedStream = CombineLatestStream.combine2(
      _getSliderImagesUseCase(), // .first ke baghair, poori stream
      _getAnnouncementsUseCase(), // .first ke baghair, poori stream
      (
        Either<Failure, List<SliderImageEntity>> sliderResult,
        Either<Failure, List<AnnouncementEntity>> announcementResult,
      ) {
        // Yeh function har update pe chalega aur dono ke latest results dega
        return [sliderResult, announcementResult];
      },
    );

    // ab is combined stream ko sunein
    await emit.forEach(
      combinedStream,
      onData: (List<Either<Failure, dynamic>> results) {
        final sliderResult =
            results[0] as Either<Failure, List<SliderImageEntity>>;
        final announcementResult =
            results[1] as Either<Failure, List<AnnouncementEntity>>;

        // Agar kisi bhi stream mein error aaye to HomeFailure state emit karein
        if (sliderResult.isLeft()) {
          return sliderResult.fold(
            (failure) => HomeFailure(message: failure.message),
            (_) => state, // impossible case
          );
        }
        if (announcementResult.isLeft()) {
          return announcementResult.fold(
            (failure) => HomeFailure(message: failure.message),
            (_) => state, // impossible case
          );
        }

        // Agar dono streams successful hain to data extract karein
        final sliderImages = sliderResult.getOrElse(() => []);
        final announcements = announcementResult.getOrElse(() => []);

        // HomeLoaded state emit karein, bilkul up-to-date data ke sath
        return HomeLoaded(
          sliderImages: sliderImages,
          latestAnnouncement: announcements.isNotEmpty
              ? announcements.first
              : null,
        );
      },
      onError: (error, stackTrace) {
        return HomeFailure(message: 'An unknown error occurred: $error');
      },
    );
  }
}
