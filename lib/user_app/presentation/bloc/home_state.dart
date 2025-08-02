// File: lib/user_app/presentation/bloc/home_state.dart
import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/announcements/domain/entities/announcement_entity.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/entities/slider_image_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<SliderImageEntity> sliderImages;
  final AnnouncementEntity? latestAnnouncement; // <-- Nayi field

  const HomeLoaded({required this.sliderImages, this.latestAnnouncement});

  @override
  List<Object?> get props => [sliderImages, latestAnnouncement];
}

class HomeFailure extends HomeState {
  final String message;
  const HomeFailure({required this.message});
}
