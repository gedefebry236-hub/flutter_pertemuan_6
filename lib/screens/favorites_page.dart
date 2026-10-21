import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

// Poin 57: Buat FavoritesPage yang hanya menampilkan course favorite
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau state. Kita memfilter courses yang hanya ada di dalam set favorites
    final state = context.watch<CourseState>();
    final favoriteCourses = state.courses.where((c) => state.isFavorite(c.code)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: favoriteCourses.isEmpty
          ? const Center(child: Text('Belum ada course favorit.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                return CourseCardReusable(course: favoriteCourses[index]);
              },
            ),
    );
  }
}