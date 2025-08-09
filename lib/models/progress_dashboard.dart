import 'package:children_cs_awareness_quiz/models/badges.dart';

import 'category.dart';
import 'user.dart';

class ProgressDashboard {
  final User user;
  final List<Category> categoryProgress;
  final List<Badges> earnedBadges;
  final List<Badges> allBadges;

  ProgressDashboard({
    required this.user,
    required this.categoryProgress,
    required this.earnedBadges,
    required this.allBadges,
  });

  factory ProgressDashboard.fromJson(Map<String, dynamic> json) {
    return ProgressDashboard(
      user: User.fromJson(json['user']),
      categoryProgress: (json['categoryProgress'] as List)
          .map((cat) => Category.fromJson(cat))
          .toList(),
      earnedBadges: (json['earnedBadges'] as List)
          .map((badge) => Badges.fromJson(badge))
          .toList(),
      allBadges: (json['allBadges'] as List)
          .map((badge) => Badges.fromJson(badge))
          .toList(),
    );
  }
}
