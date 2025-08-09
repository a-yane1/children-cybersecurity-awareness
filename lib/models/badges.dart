class Badges {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String requirementType;
  final int requirementValue;
  final DateTime? earnedAt;
  final bool isEarned;

  Badges({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.requirementType,
    required this.requirementValue,
    this.earnedAt,
    this.isEarned = false,
  });

  factory Badges.fromJson(Map<String, dynamic> json) {
    return Badges(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      icon: json['icon'] ?? '🏆',
      requirementType: json['requirement_type'],
      requirementValue: json['requirement_value'],
      earnedAt: json['earned_at'] != null
          ? DateTime.parse(json['earned_at'])
          : null,
      isEarned: json['earned_at'] != null,
    );
  }
}
