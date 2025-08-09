class Question {
  final int id;
  final int categoryId;
  final String questionText;
  final String? imageUrl;
  final int points;
  final String explanation;
  final String? hintText;
  final String typeName;
  final List<AnswerOption> options;

  Question({
    required this.id,
    required this.categoryId,
    required this.questionText,
    this.imageUrl,
    required this.points,
    required this.explanation,
    this.hintText,
    required this.typeName,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      categoryId: json['category_id'],
      questionText: json['question_text'],
      imageUrl: json['image_url'],
      points: json['points'] ?? 10,
      explanation: json['explanation'] ?? '',
      hintText: json['hint_text'],
      typeName: json['type_name'] ?? 'multiple_choice',
      options:
          (json['options'] as List?)
              ?.map((option) => AnswerOption.fromJson(option))
              .toList() ??
          [],
    );
  }
}

class AnswerOption {
  final int id;
  final String optionText;
  final String? icon;
  final String? imageUrl;
  final int orderPosition;

  AnswerOption({
    required this.id,
    required this.optionText,
    this.icon,
    this.imageUrl,
    required this.orderPosition,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json['id'],
      optionText: json['option_text'],
      icon: json['icon'],
      imageUrl: json['image_url'],
      orderPosition: json['order_position'] ?? 1,
    );
  }
}
