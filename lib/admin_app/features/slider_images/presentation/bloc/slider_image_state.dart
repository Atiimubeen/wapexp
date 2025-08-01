import 'package:equatable/equatable.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/entities/slider_image_entity.dart';

abstract class SliderImageState extends Equatable {
  const SliderImageState();
  @override
  List<Object> get props => [];
}

class SliderImageInitial extends SliderImageState {}

class SliderImageLoading extends SliderImageState {}

class SliderImageActionSuccess extends SliderImageState {
  final String message;
  const SliderImageActionSuccess({required this.message});
}

class SliderImagesLoaded extends SliderImageState {
  final List<SliderImageEntity> images;
  const SliderImagesLoaded({required this.images});
}

class SliderImageFailure extends SliderImageState {
  final String message;
  const SliderImageFailure({required this.message});
}
