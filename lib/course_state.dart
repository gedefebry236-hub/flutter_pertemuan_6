import 'package:flutter/material.dart';
import 'models/course.dart';
import 'repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  // Poin 46: Tambahkan repository sebagai dependency
  final CourseRepository repository;

  CourseState(this.repository);

  // State untuk Async Data
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // State untuk Favorites
  final Set<String> favorites = {};

  // Poin 47: Implementasikan loadCourses()
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners(); // Beritahu UI untuk menampilkan loading

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // Beritahu UI bahwa loading selesai (sukses/gagal)
    }
  }

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }
}