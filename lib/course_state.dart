import 'package:flutter/material.dart';

// Class state terpisah menggunakan ChangeNotifier
class CourseState extends ChangeNotifier {
  
  // 23. Tambahkan collection favorites.
  // Menggunakan Set agar tidak ada duplikasi ID/kode mata kuliah
  final Set<String> favorites = {};

  // 24. Tambahkan method toggleFavorite().
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id); // Hapus jika sudah ada
    } else {
      favorites.add(id); // Tambah jika belum ada
    }
    
    // 25. Pastikan notifyListeners() dipanggil setelah state berubah.
    notifyListeners();
  }
}