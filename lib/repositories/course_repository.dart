// 2415051009 - Febrian
// lib/repositories/course_repository.dart
import '../models/course.dart';
import '../services/course_data_source.dart'; // Bergantung pada abstraksi

class CourseRepository {
  // Constructor kini menerima interface CourseDataSource
  CourseRepository(this.dataSource);
  
  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() async => dataSource.getCourses();
  
  Future<Course> createCourse(Course course) async => 
      dataSource.createCourse(course);
      
  Future<void> updateCourse(String code, Course course) async => 
      dataSource.updateCourse(code, course);
      
  Future<void> deleteCourse(String code) async => 
      dataSource.deleteCourse(code);
}