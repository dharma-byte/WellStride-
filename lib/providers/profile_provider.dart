import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/profile/services/profile_repository.dart';
import '../models/user_model.dart';
import 'auth_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(FirebaseFirestore.instance);
});

final profileStreamProvider = StreamProvider<UserProfile?>((ref) async* {
  final user = await ref.watch(authStateChangesProvider.future);
  if (user == null) {
    yield null;
    return;
  }

  final repository = ref.watch(profileRepositoryProvider);
  await repository.ensureProfileExists(uid: user.uid, email: user.email ?? '');
  yield* repository.watchProfile(user.uid);
});
