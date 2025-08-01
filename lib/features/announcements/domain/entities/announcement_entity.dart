import 'package:equatable/equatable.dart';

class AnnouncementEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  const AnnouncementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, title, description, date];
}
