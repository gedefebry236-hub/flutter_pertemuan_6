import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository repository;

  CourseState(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;
  final Set<String> favorites = {};

  // Poin 55: Tambahkan helper isFavorite
  bool isFavorite(String code) => favorites.contains(code);

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(String code) {
    favorites.contains(code) ? favorites.remove(code) : favorites.add(code);
    notifyListeners();
  }
}