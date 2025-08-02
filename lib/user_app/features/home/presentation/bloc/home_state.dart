import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/entities/slider_image_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<SliderImageEntity> sliderImages;
  // Hum yahan baqi data (courses, etc.) bhi add kar sakte hain
  const HomeLoaded({required this.sliderImages});
  @override
  List<Object> get props => [sliderImages];
}

class HomeFailure extends HomeState {
  final String message;
  const HomeFailure({required this.message});
}
