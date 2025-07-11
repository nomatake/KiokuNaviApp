import 'topic.dart';

class Chapter {
  final int id;
  final int courseId;
  final String title;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Topic>? topics;

  Chapter({
    required this.id,
    required this.courseId,
    required this.title,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.topics,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      order: json['order'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      topics: json['topics'] != null
          ? (json['topics'] as List)
              .map((topic) => Topic.fromJson(topic))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'topics': topics?.map((topic) => topic.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chapter &&
        other.id == id &&
        other.courseId == courseId &&
        other.title == title &&
        other.order == order &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        courseId.hashCode ^
        title.hashCode ^
        order.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Chapter{id: $id, courseId: $courseId, title: $title, order: $order, createdAt: $createdAt, updatedAt: $updatedAt, topics: $topics}';
  }

  Chapter copyWith({
    int? id,
    int? courseId,
    String? title,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Topic>? topics,
  }) {
    return Chapter(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      topics: topics ?? this.topics,
    );
  }
}
