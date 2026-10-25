class Course {
  final int? id; // Tambahan field id (nullable)
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  // Konversi dari JSON ke Objek Dart
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      // Beri nilai default jika API JSONPlaceholder tidak memiliki field ini
      code: json['code'] as String? ?? 'DUMMY-${json['id']}', 
      title: json['title'] as String? ?? 'No Title',
      credits: json['credits'] as int? ?? 2,
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  // Konversi dari Objek Dart ke JSON (untuk persiapan POST/PUT)
  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };
}