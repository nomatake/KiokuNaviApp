import 'topic.dart';

class Chapter {
  final int id;
  final int courseId;
  final String title;
  final String? description;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Topic>? topics;
  final int? topicsCount;

  Chapter({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.topics,
    this.topicsCount,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int,
      courseId: json['course_id'] as int,
      title: json['title'],
      description: json['description'],
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      topics: json['topics'] != null
          ? (json['topics'] as List)
              .map((topic) => Topic.fromJson(topic))
              .toList()
          : null,
      topicsCount: json['topics_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'topics': topics?.map((topic) => topic.toJson()).toList(),
      'topics_count': topicsCount,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chapter &&
        other.id == id &&
        other.courseId == courseId &&
        other.title == title &&
        other.description == description &&
        other.order == order &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.topicsCount == topicsCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        courseId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        order.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        topicsCount.hashCode;
  }

  @override
  String toString() {
    return 'Chapter{id: $id, courseId: $courseId, title: $title, description: $description, order: $order, createdAt: $createdAt, updatedAt: $updatedAt, topics: $topics, topicsCount: $topicsCount}';
  }

  Chapter copyWith({
    int? id,
    int? courseId,
    String? title,
    String? description,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Topic>? topics,
    int? topicsCount,
  }) {
    return Chapter(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      topics: topics ?? this.topics,
      topicsCount: topicsCount ?? this.topicsCount,
    );
  }
}
