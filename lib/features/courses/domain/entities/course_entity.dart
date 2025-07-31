import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String price;
  final String? discountedPrice; // Optional
  final String duration;
  final String imageUrl;
  final DateTime? startDate; // Optional
  final DateTime? endDate; // Optional
  final DateTime? offerEndDate; // Optional

  const CourseEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.duration,
    required this.imageUrl,
    this.startDate,
    this.endDate,
    this.offerEndDate,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    discountedPrice,
    duration,
    imageUrl,
    startDate,
    endDate,
    offerEndDate,
  ];
}
