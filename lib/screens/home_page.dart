import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

const String studentName = 'Febrian';
const String studentId = '2415051009';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();
    final favoriteCount = courseState.favorites.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Courses'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo.shade50,
            width: double.infinity,
            child: Text(
              'Total Favorit: $favoriteCount\n$studentId - $studentName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: _buildCourseContent(courseState),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseContent(CourseState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.error != null) {
      return Center(
        child: Text('Terjadi Kesalahan:\n${state.error}', textAlign: TextAlign.center),
      );
    } else if (state.courses.isEmpty) {
      return const Center(child: Text('Tidak ada data courses'));
    } else {
      return ListView.builder(
        itemCount: state.courses.length,
        itemBuilder: (context, index) {
          return CourseCardReusable(course: state.courses[index]);
        },
      );
    }
  }
}