import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';

class CourseCardReusable extends StatelessWidget {
  final Course course;

  const CourseCardReusable({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        // Menambahkan Navigasi ke DetailPage
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseDetailPage(course: course)),
          );
        },
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: const Icon(Icons.book, color: Colors.indigo),
        ),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${course.code} • ${course.credits} SKS • ${course.status}'),
        trailing: Consumer<CourseState>(
          builder: (context, courseState, child) {
            final isFavorite = courseState.isFavorite(course.code);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                context.read<CourseState>().toggleFavorite(course.code);
              },
            );
          },
        ),
      ),
    );
  }
}