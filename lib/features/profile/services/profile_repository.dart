import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/user_model.dart';

class ProfileRepository {
  ProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _userDoc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return UserProfile.fromFirestore(uid, data);
    });
  }

  Future<void> ensureProfileExists({
    required String uid,
    required String email,
  }) async {
    final doc = _userDoc(uid);
    final snapshot = await doc.get();
    if (snapshot.exists) return;

    await doc.set({
      'email': email,
      'name': '',
      'phoneNumber': '',
      'unitPreference': UnitPreference.metric.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveProfile(UserProfile profile) {
    return _userDoc(
      profile.uid,
    ).set(profile.toFirestore(), SetOptions(merge: true));
  }
}
