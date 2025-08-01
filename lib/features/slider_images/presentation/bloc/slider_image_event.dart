import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:wapexp/features/slider_images/domain/entities/slider_image_entity.dart';

abstract class SliderImageEvent extends Equatable {
  const SliderImageEvent();
  @override
  List<Object?> get props => [];
}

class AddSliderImage extends SliderImageEvent {
  final File image;
  const AddSliderImage({required this.image});
}

class DeleteSliderImage extends SliderImageEvent {
  final SliderImageEntity image;
  const DeleteSliderImage({required this.image});
}

class LoadSliderImages extends SliderImageEvent {}
