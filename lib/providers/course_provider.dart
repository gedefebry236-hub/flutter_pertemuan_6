import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository _repository;
  
  CourseState(this._repository);

  List<Course> _courses = [];
  bool _isLoading = false;
  bool _isSaving = false; 
  String? _error;
  final Set<String> _favoriteCodes = {};

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

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

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _courses = await _repository.getCourses();
    } catch (e) {
      _error = 'Terjadi kesalahan:\n$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCourse(Course course) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.createCourse(course);
      await loadCourses();
      return true;
    } catch (e) {
      _error = 'Gagal menyimpan course: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> editCourse(String code, Course updatedCourse) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.updateCourse(code, updatedCourse);
      await loadCourses();
      return true;
    } catch (e) {
      _error = 'Gagal memperbarui: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Tahap 8: Method DELETE
  Future<bool> deleteCourse(String code) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteCourse(code);
      
      // Poin 51: Hapus dari favorites agar tidak ada data yatim
      if (_favoriteCodes.contains(code)) {
        _favoriteCodes.remove(code);
      }
      
      await loadCourses(); // Poin 49: Refresh list
      return true;
    } catch (e) {
      _error = 'Gagal menghapus course: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}