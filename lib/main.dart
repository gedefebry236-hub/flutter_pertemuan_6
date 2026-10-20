import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_state.dart';

// --- IDENTITAS MAHASISWA ---
const String studentName = 'Febrian';
const String studentId = '2415051009';

void main() {
  runApp(
    // 28. Bungkus aplikasi dengan ChangeNotifierProvider di akar widget tree
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

  final List<Map<String, String>> dummyCourses = const [
    {'title': 'Pemrograman Mobile', 'code': 'MOB04', 'status': 'Active'},
    {'title': 'Pemrograman Web', 'code': 'WEB05', 'status': 'Active'},
    {'title': 'Jaringan Komputer', 'code': 'NET06', 'status': 'Done'},
  ];

  @override
  Widget build(BuildContext context) {
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
            child: const Text(
              'Provider Terpasang di Widget Tree\n$studentId - $studentName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dummyCourses.length,
              itemBuilder: (context, index) {
                final course = dummyCourses[index];
                return ListTile(
                  leading: const Icon(Icons.book, color: Colors.indigo),
                  title: Text(course['title']!),
                  subtitle: Text(course['code']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}