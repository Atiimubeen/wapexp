import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wapexp/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    super.imageUrl,
  });

  // **THE FIX IS HERE**
  // Humne is factory constructor ko update kiya hai.
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    // Pehle check karo ke document mein data hai ya nahi.
    if (doc.data() == null) {
      // Agar data nahi hai, to ek khaali (empty) user bana do taake app crash na ho.
      // Yeh soorat-e-haal sirf signup ke waqt 1 second ke liye ho sakti hai.
      return const UserModel(uid: '', name: 'No Name', email: 'No Email');
    }

    // Agar data hai, to usko 'map' mein badlo.
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Aur phir UserModel bana kar return karo.
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }
}
