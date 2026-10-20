import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_state.dart';
import 'models/course.dart'; // Import model Course

// --- IDENTITAS MAHASISWA ---
const String studentName = 'Febrian';
const String studentId = '2415051009';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(),
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

  // Poin 37: Ubah data JSON menjadi object Course
  // Simulasi data JSON dari API
  final List<Map<String, dynamic>> rawJsonData = const [
    {'title': 'Pemrograman Mobile', 'code': 'MOB04', 'credits': 3, 'status': 'Active'},
    {'title': 'Pemrograman Web', 'code': 'WEB05', 'credits': 3, 'status': 'Active'},
    {'title': 'Jaringan Komputer', 'code': 'NET06', 'credits': 2, 'status': 'Done'},
  ];

  @override
  Widget build(BuildContext context) {
    // Parsing list of map (JSON) menjadi List of Course Objects
    final List<Course> courseList = rawJsonData.map((json) => Course.fromJson(json)).toList();
    
    final favoriteCount = context.watch<CourseState>().favorites.length;

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
            child: ListView.builder(
              itemCount: courseList.length,
              itemBuilder: (context, index) {
                final course = courseList[index]; // Ini sekarang adalah objek Course, bukan Map
                
                return CourseCardReusable(
                  course: course, // Kirimkan seluruh objek Course ke child widget
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCardReusable extends StatelessWidget {
  final Course course;

  const CourseCardReusable({
    super.key,
    required this.course,
  });

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
        // Poin 37: Tampilkan ke UI dengan mengakses property object (misal: course.title)
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