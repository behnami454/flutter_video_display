class Video {
  final int id;
  final String title;
  final String path;
  final String category;

  Video({
    required this.id,
    required this.title,
    required this.path,
    required this.category,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      path: json['path'],
      category: json['category'],
    );
  }
}
