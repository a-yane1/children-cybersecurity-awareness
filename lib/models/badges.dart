class Badges {
  final String id;
  final String name;
  final String image;
  final String description;
  final bool isUnlocked;

  Badges({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    this.isUnlocked = false,
  });
}
