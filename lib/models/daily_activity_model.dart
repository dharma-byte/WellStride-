class DailyActivity {
  const DailyActivity({
    required this.date,
    this.steps = 0,
    this.distanceKm = 0,
    this.caloriesBurned = 0,
    this.goalStepsMet = false,
  });

  /// Format: YYYY-MM-DD, also used as the Firestore document ID.
  final String date;
  final int steps;
  final double distanceKm;
  final double caloriesBurned;
  final bool goalStepsMet;

  factory DailyActivity.fromFirestore(String date, Map<String, dynamic> data) {
    return DailyActivity(
      date: date,
      steps: (data['steps'] as num?)?.toInt() ?? 0,
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0,
      caloriesBurned: (data['caloriesBurned'] as num?)?.toDouble() ?? 0,
      goalStepsMet: data['goalStepsMet'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'steps': steps,
      'distanceKm': distanceKm,
      'caloriesBurned': caloriesBurned,
      'goalStepsMet': goalStepsMet,
    };
  }
}
