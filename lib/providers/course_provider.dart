import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository _repository;
  
  CourseState(this._repository);

  List<Course> _courses = [];
  bool _isLoading = false;
  bool _isSaving = false; // Flag isSaving untuk indikator loading submit (Poin 37)
  String? _error;
  final Set<String> _favoriteCodes = {};

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  // Fitur Favorit
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

  // Fitur REST API GET
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

  // Fitur REST API POST (Poin 36 & 40)
  Future<bool> addCourse(Course course) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.createCourse(course);
      await loadCourses(); // Poin 40: Refresh list setelah berhasil
      return true;
    } catch (e) {
      _error = 'Gagal menyimpan course: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}