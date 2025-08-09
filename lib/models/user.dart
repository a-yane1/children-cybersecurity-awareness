class User {
  final int id;
  final String name;
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final DateTime createdAt;
  final DateTime lastActive;

  User({
    required this.id,
    required this.name,
    required this.totalPoints,
    required this.currentStreak,
    required this.bestStreak,
    required this.createdAt,
    required this.lastActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      totalPoints: json['total_points'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
      bestStreak: json['best_streak'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      lastActive: DateTime.parse(json['last_active']),
    );
  }
}
