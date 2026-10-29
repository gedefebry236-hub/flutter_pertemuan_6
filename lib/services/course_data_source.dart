// lib/services/course_data_source.dart
import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(String code, Course course);
  Future<void> deleteCourse(String code);
}