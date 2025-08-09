import 'package:children_cs_awareness_quiz/models/badges.dart';

class AnswerResult {
  final bool isCorrect;
  final int pointsEarned;
  final String explanation;
  final String correctAnswer;
  final List<Badges> newBadges;

  AnswerResult({
    required this.isCorrect,
    required this.pointsEarned,
    required this.explanation,
    required this.correctAnswer,
    required this.newBadges,
  });

  factory AnswerResult.fromJson(Map<String, dynamic> json) {
    return AnswerResult(
      isCorrect: json['isCorrect'],
      pointsEarned: json['pointsEarned'] ?? 0,
      explanation: json['explanation'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      newBadges:
          (json['newBadges'] as List?)
              ?.map((badge) => Badges.fromJson(badge))
              .toList() ??
          [],
    );
  }
}
