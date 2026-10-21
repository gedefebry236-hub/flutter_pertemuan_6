import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_state.dart';
import 'models/course.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';

const String studentName = 'Febrian';
const String studentId = '2415051009';

void main() {
  // Inisialisasi Service dan Repository di awal
  final courseService = CourseService();
  final courseRepository = CourseRepository(courseService);

  runApp(
    ChangeNotifierProvider(
      // Inject repository ke dalam CourseState saat dibuat
      create: (_) => CourseState(courseRepository)..loadCourses(), 
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CoursesPage(),
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita gunakan watch() untuk memantau seluruh state
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
            // Poin 48, 49, 50: Menangani Async State di UI
            child: _buildCourseContent(courseState),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseContent(CourseState state) {
    // Poin 48: Tampilkan CircularProgressIndicator saat loading[cite: 24]
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } 
    // Poin 49: Tampilkan pesan jika error tidak null[cite: 24]
    else if (state.error != null) {
      return Center(
        child: Text('Terjadi Kesalahan:\n${state.error}', textAlign: TextAlign.center),
      );
    } 
    // Poin 50: Tampilkan list jika data berhasil[cite: 24]
    else if (state.courses.isEmpty) {
      return const Center(child: Text('Tidak ada data courses'));
    } 
    else {
      return ListView.builder(
        itemCount: state.courses.length,
        itemBuilder: (context, index) {
          return CourseCardReusable(course: state.courses[index]);
        },
      );
    }
  }
}

class CourseCardReusable extends StatelessWidget {
  final Course course;

  const CourseCardReusable({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: const Icon(Icons.book, color: Colors.indigo),
        ),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${course.code} • ${course.credits} SKS • ${course.status}'),
        trailing: Consumer<CourseState>(
          builder: (context, courseState, child) {
            final isFavorite = courseState.favorites.contains(course.code);
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