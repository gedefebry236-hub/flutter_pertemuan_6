import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  CourseRepository(this.apiService);
  final CourseApiService apiService;

  Future<List<Course>> getCourses() async => await apiService.getCourses();
  Future<Course> createCourse(Course course) async => await apiService.createCourse(course);
  Future<void> updateCourse(String code, Course course) async => await apiService.updateCourse(code, course);
  
  // Tahap 8: Teruskan method delete
  Future<void> deleteCourse(String code) async {
    return await apiService.deleteCourse(code);
  }
}