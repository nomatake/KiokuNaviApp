import 'chapter.dart';

class Course {
  final int id;
  final String title;
  final String? description;
  final String? iconUrl;
  final String? gradeLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Chapter>? chapters;

  Course({
    required this.id,
    required this.title,
    this.description,
    this.iconUrl,
    this.gradeLevel,
    required this.createdAt,
    required this.updatedAt,
    this.chapters,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      title: json['title'],
      description: json['description'],
      iconUrl: json['icon_url'],
      gradeLevel: json['grade_level'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      chapters: json['chapters'] != null
          ? (json['chapters'] as List)
              .map((chapter) => Chapter.fromJson(chapter))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_url': iconUrl,
      'grade_level': gradeLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'chapters': chapters?.map((chapter) => chapter.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.iconUrl == iconUrl &&
        other.gradeLevel == gradeLevel &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        iconUrl.hashCode ^
        gradeLevel.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Course{id: $id, title: $title, description: $description, iconUrl: $iconUrl, gradeLevel: $gradeLevel, createdAt: $createdAt, updatedAt: $updatedAt, chapters: $chapters}';
  }

  Course copyWith({
    int? id,
    String? title,
    String? description,
    String? iconUrl,
    String? gradeLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Chapter>? chapters,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chapters: chapters ?? this.chapters,
    );
  }
}
