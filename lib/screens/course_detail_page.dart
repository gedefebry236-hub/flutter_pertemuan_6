import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

// Poin 56: Tampilkan status favorite pada DetailPage
class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Consumer<CourseState>(
            builder: (context, state, child) {
              final isFav = state.isFavorite(course.code);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () => context.read<CourseState>().toggleFavorite(course.code),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode Matkul: ${course.code}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Beban SKS: ${course.credits} SKS', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text('Status: ${course.status}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}