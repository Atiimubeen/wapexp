import 'package:equatable/equatable.dart';

class SliderImageEntity extends Equatable {
  final String id;
  final String imageUrl;

  const SliderImageEntity({required this.id, required this.imageUrl});

  @override
  List<Object?> get props => [id, imageUrl];
}
