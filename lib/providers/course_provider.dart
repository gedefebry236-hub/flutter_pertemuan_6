import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository _repository;
  
  CourseState(this._repository);

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;
  final Set<String> _favoriteCodes = {};

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- Fitur Favorit Pertemuan 6 ---
  Set<String> get favoriteCodes => _favoriteCodes;

  bool isFavorite(String code) => _favoriteCodes.contains(code);

  void toggleFavorite(String code) {
    if (_favoriteCodes.contains(code)) {
      _favoriteCodes.remove(code);
    } else {
      _favoriteCodes.add(code);
    }
    notifyListeners();
  }

  List<Course> get favoriteCourses {
    return _courses.where((c) => _favoriteCodes.contains(c.code)).toList();
  }

  // --- Fitur REST API Pertemuan 7 ---
  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
    } catch (e) {
      _error = 'Terjadi kesalahan saat memuat data:\n$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}