enum UserType { student, parent }

class User {
  final int id;
  final String name;
  final UserType type;
  final String? studentId;
  final String? email;
  final int? grade;
  final List<User>? children;
  
  User({
    required this.id,
    required this.name,
    required this.type,
    this.studentId,
    this.email,
    this.grade,
    this.children,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      type: json['type'] == 'student' ? UserType.student : UserType.parent,
      studentId: json['student_id'],
      email: json['email'],
      grade: json['grade'],
      children: json['children'] != null
          ? (json['children'] as List)
              .map((child) => User.fromJson(child))
              .toList()
          : null,
    );
  }
}