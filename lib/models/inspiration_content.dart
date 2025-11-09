class InspirationContent {
  final String title;
  final String subtitle;
  final String imagePath;
  final String description;
  final String category;
  final DateTime? publishedDate;
  final int? readTimeMinutes;
  final bool isFeatured;

  InspirationContent({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.description,
    required this.category,
    this.publishedDate,
    this.readTimeMinutes,
    this.isFeatured = false,
  });

  factory InspirationContent.fromJson(Map<String, dynamic> json) {
    return InspirationContent(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imagePath: json['imagePath'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      publishedDate: json['publishedDate'] != null 
          ? DateTime.parse(json['publishedDate'])
          : null,
      readTimeMinutes: json['readTimeMinutes'],
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
      'description': description,
      'category': category,
      'publishedDate': publishedDate?.toIso8601String(),
      'readTimeMinutes': readTimeMinutes,
      'isFeatured': isFeatured,
    };
  }
}
