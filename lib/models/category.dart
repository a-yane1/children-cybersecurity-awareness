class Category {
  final int id;
  final String name;
  final String icon;
  final String description;
  final int totalQuestions;
  final int questionsAnswered;
  final int correctAnswers;
  final int pointsEarned;
  final bool isCompleted;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.totalQuestions,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.pointsEarned,
    required this.isCompleted,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'] ?? '',
      totalQuestions: json['total_questions'] ?? 0,
      questionsAnswered: json['questions_answered'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      pointsEarned: json['points_earned'] ?? 0,
      isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
    );
  }

  double get progressPercentage {
    if (totalQuestions == 0) return 0.0;
    return (questionsAnswered / totalQuestions).clamp(0.0, 1.0);
  }

  double get accuracyPercentage {
    if (questionsAnswered == 0) return 0.0;
    return (correctAnswers / questionsAnswered).clamp(0.0, 1.0);
  }
}
