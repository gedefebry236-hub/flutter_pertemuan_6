import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

// ==========================================
// 2415051009 - Febrian
// ==========================================
class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  String get _uid => supabase.auth.currentUser!.id;

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
    final payload = {
      ...course.toJson(),
      'owner_id': _uid,
    };

    final row = await supabase
        .from('courses')
        .insert(payload)
        .select()
        .single();

    return Course.fromJson(row);
  }

  @override
  Future<void> updateCourse(String code, Course course) async {
    final payload = course.toJson()..remove('owner_id');

    final rows = await supabase
        .from('courses')
        .update(payload)
        .eq('code', code)
        .select();

    // Jika ditolak RLS pada baris milik orang lain, Supabase mengembalikan list kosong
    if ((rows as List).isEmpty) {
      throw Exception('Ditolak RLS: Anda tidak memiliki izin mengubah course ini.');
    }
  }

  // 2415051009 - Febrian
  @override
  Future<void> deleteCourse(String code) async {
    final rows = await supabase
        .from('courses')
        .delete()
        .eq('code', code)
        .select();

    // Jika ditolak RLS pada baris milik orang lain, Supabase mengembalikan list kosong
    if ((rows as List).isEmpty) {
      throw Exception('Ditolak RLS: Anda tidak memiliki izin menghapus course ini.');
    }
  }
}