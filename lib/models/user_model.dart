import 'package:cloud_firestore/cloud_firestore.dart';

enum UnitPreference {
  metric,
  imperial;

  static UnitPreference fromName(String? name) {
    return name == 'imperial' ? UnitPreference.imperial : UnitPreference.metric;
  }
}

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    this.name = '',
    this.phoneNumber = '',
    this.weightKg,
    this.heightCm,
    this.age,
    this.unitPreference = UnitPreference.metric,
    this.createdAt,
  });

  final String uid;
  final String email;
  final String name;
  final String phoneNumber;
  final double? weightKg;
  final double? heightCm;
  final int? age;
  final UnitPreference unitPreference;
  final DateTime? createdAt;

  /// Body Mass Index, derived from weight and height. Null until both are set.
  double? get bmi {
    final weight = weightKg;
    final height = heightCm;
    if (weight == null || height == null || height == 0) return null;
    final heightMeters = height / 100;
    return weight / (heightMeters * heightMeters);
  }

  factory UserProfile.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      weightKg: (data['weightKg'] as num?)?.toDouble(),
      heightCm: (data['heightCm'] as num?)?.toDouble(),
      age: data['age'] as int?,
      unitPreference: UnitPreference.fromName(data['unitPreference'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'age': age,
      'unitPreference': unitPreference.name,
    };
  }

  UserProfile copyWith({
    String? name,
    String? phoneNumber,
    double? weightKg,
    double? heightCm,
    int? age,
    UnitPreference? unitPreference,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
      unitPreference: unitPreference ?? this.unitPreference,
      createdAt: createdAt,
    );
  }
}
