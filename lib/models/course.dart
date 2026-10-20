// Poin 34: Buat lib/models/course.dart
class Course {
  // Poin 35: Tambahkan field minimal code, title, credits, status
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  // Poin 36: Tambahkan factory Course.fromJson()
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }
}