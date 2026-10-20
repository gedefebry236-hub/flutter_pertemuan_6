import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_state.dart';

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

  final List<Map<String, String>> dummyCourses = const [
    {'title': 'Pemrograman Mobile', 'code': 'MOB04', 'status': 'Active'},
    {'title': 'Pemrograman Web', 'code': 'WEB05', 'status': 'Active'},
    {'title': 'Jaringan Komputer', 'code': 'NET06', 'status': 'Done'},
  ];

  @override
  Widget build(BuildContext context) {
    // 30. Gunakan watch() untuk menampilkan jumlah favorite.
    // context.watch() akan mendengarkan perubahan dan me-rebuild widget ini.
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
              itemCount: dummyCourses.length,
              itemBuilder: (context, index) {
                final course = dummyCourses[index];
                return CourseCardReusable(
                  title: course['title']!,
                  code: course['code']!,
                  status: course['status']!,
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
  final String title;
  final String code;
  final String status;

  const CourseCardReusable({
    super.key,
    required this.title,
    required this.code,
    required this.status,
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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$code • $status'),
        // 32. Gunakan Consumer pada satu bagian kecil UI (hanya ikon tombol).
        trailing: Consumer<CourseState>(
          builder: (context, courseState, child) {
            final isFavorite = courseState.favorites.contains(code);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                // 31. Gunakan read() pada tombol toggle favorite.
                // read() dipanggil saat aksi (tanpa listen/rebuild).
                context.read<CourseState>().toggleFavorite(code);
              },
            );
          },
        ),
      ),
    );
  }
}