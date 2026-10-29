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

  @override
  Future<void> updateCourse(String code, Course course) async {
    await supabase
        .from('courses')
        .update(course.toJson())
        .eq('code', code);
  }
  //2415051009 - Febrian
  // Mengganti stub deleteCourse sesuai Tahap 15
  @override
  Future<void> deleteCourse(String code) async {
    await supabase
        .from('courses')
        .delete()
        .eq('code', code);
  }
}