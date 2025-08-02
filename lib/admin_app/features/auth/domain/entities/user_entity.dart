import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? imageUrl;
  final bool isAdmin; // <-- Nayi field

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.imageUrl,
    this.isAdmin = false,
  });

  @override
  List<Object?> get props => [uid, name, email, imageUrl, isAdmin];
}
