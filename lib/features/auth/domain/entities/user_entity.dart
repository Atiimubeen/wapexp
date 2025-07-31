import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? imageUrl;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [uid, name, email, imageUrl];
}
