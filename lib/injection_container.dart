import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:wapexp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:wapexp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wapexp/features/auth/domain/repositories/auth_repository.dart';

// get_it ka instance
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Is function mein hum apni saari classes ko manually register karenge.

  // ================= EXTERNAL (3rd Party) =================
  // Firebase ki services ko register karna
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // ================= DATA SOURCES =================
  // AuthRemoteDataSource ko register karna
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
      storage: getIt<FirebaseStorage>(),
    ),
  );

  // ================= REPOSITORIES =================
  // AuthRepository ko register karna
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // Jab hum BLoC/Use Cases banayenge, to unko bhi yahin register karenge.
}
