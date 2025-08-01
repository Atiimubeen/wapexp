import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String id;
  final String name;
  final DateTime date;
  final String coverImageUrl;
  final List<String> galleryImageUrls;

  const SessionEntity({
    required this.id,
    required this.name,
    required this.date,
    required this.coverImageUrl,
    required this.galleryImageUrls,
  });

  @override
  List<Object?> get props => [id, name, date, coverImageUrl, galleryImageUrls];
}
