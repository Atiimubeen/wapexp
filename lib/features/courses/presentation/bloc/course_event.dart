import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
  @override
  List<Object?> get props => [];
}

class AddCourseButtonPressed extends CourseEvent {
  final String name;
  final String description;
  final String price;
  final String? discountedPrice;
  final String duration;
  final File image;
  final String? startDate;
  final String? endDate;
  final String? offerEndDate;

  const AddCourseButtonPressed({
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.duration,
    required this.image,
    this.startDate,
    this.endDate,
    this.offerEndDate,
  });

  @override
  List<Object?> get props => [
    name,
    description,
    price,
    discountedPrice,
    duration,
    image,
    startDate,
    endDate,
    offerEndDate,
  ];
}
