import 'question.dart';

class Topic {
  final int id;
  final int chapterId;
  final String title;
  final String? iconText;
  final String? description;
  final int order;
  final int? unlockLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Question>? contentBlocks;

  Topic({
    required this.id,
    required this.chapterId,
    required this.title,
    this.iconText,
    this.description,
    required this.order,
    this.unlockLevel,
    required this.createdAt,
    required this.updatedAt,
    this.contentBlocks,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      chapterId: json['chapter_id'] as int,
      title: json['title'],
      iconText: json['icon_text'],
      description: json['description'],
      order: json['order'] as int,
      unlockLevel: json['unlock_level'] as int?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      contentBlocks: json['content_blocks'] != null
          ? (json['content_blocks'] as List)
              .map((block) => Question.fromJson(block))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'title': title,
      'icon_text': iconText,
      'description': description,
      'order': order,
      'unlock_level': unlockLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'content_blocks': contentBlocks?.map((block) => block.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Topic &&
        other.id == id &&
        other.chapterId == chapterId &&
        other.title == title &&
        other.iconText == iconText &&
        other.description == description &&
        other.order == order &&
        other.unlockLevel == unlockLevel &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chapterId.hashCode ^
        title.hashCode ^
        iconText.hashCode ^
        description.hashCode ^
        order.hashCode ^
        unlockLevel.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Topic{id: $id, chapterId: $chapterId, title: $title, iconText: $iconText, description: $description, order: $order, unlockLevel: $unlockLevel, createdAt: $createdAt, updatedAt: $updatedAt, contentBlocks: $contentBlocks}';
  }

  Topic copyWith({
    int? id,
    int? chapterId,
    String? title,
    String? iconText,
    String? description,
    int? order,
    int? unlockLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Question>? contentBlocks,
  }) {
    return Topic(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      iconText: iconText ?? this.iconText,
      description: description ?? this.description,
      order: order ?? this.order,
      unlockLevel: unlockLevel ?? this.unlockLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentBlocks: contentBlocks ?? this.contentBlocks,
    );
  }
}
