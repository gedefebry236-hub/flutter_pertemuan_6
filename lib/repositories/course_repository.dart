import '../models/course.dart';
import '../services/course_service.dart';

// Poin 42: Buat lib/repositories/course_repository.dart
class CourseRepository {
  final CourseService service;

  // Poin 43: Terima CourseService melalui constructor
  CourseRepository(this.service);

  // Poin 44: Buat method getCourses()
  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}