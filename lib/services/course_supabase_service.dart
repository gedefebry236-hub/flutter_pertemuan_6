import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

// ==========================================
// 2415051009 - Febrian
// ==========================================
class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select();

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(row);
  }

  // 2415051009 - Febrian
  // Mengganti stub updateCourse sesuai Tahap 14
  @override
  Future<void> updateCourse(String code, Course course) async {
    await supabase
        .from('courses')
        .update(course.toJson())
        .eq('code', code); // Mengupdate berdasarkan kolom code (misal: 'PTI-101')
  }

  @override
  Future<void> deleteCourse(String code) => throw UnimplementedError();
}