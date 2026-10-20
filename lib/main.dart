import 'package:flutter/material.dart';

// --- IDENTITAS MAHASISWA ---
const String studentName = 'Febrian';
const String studentId = '2415051009';

void main() {
  runApp(const CourseExplorerApp());
}

// 18. Buat ValueNotifier<int> untuk nilai sederhana (Jumlah Favorite)
final ValueNotifier<int> favoriteCountNotifier = ValueNotifier<int>(0);

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

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final List<String> _favoriteCourseCodes = [];
  
  final List<Map<String, String>> dummyCourses = [
    {'title': 'Pemrograman Mobile', 'code': 'MOB04', 'status': 'Active'},
    {'title': 'Pemrograman Web', 'code': 'WEB05', 'status': 'Active'},
    {'title': 'Jaringan Komputer', 'code': 'NET06', 'status': 'Done'},
  ];

  void _toggleFavorite(String courseCode) {
    setState(() {
      if (_favoriteCourseCodes.contains(courseCode)) {
        _favoriteCourseCodes.remove(courseCode);
        // Mengurangi nilai ValueNotifier
        favoriteCountNotifier.value--; 
      } else {
        _favoriteCourseCodes.add(courseCode);
        // 20. Tambahkan button yang mengubah value (Menambah nilai ValueNotifier)
        favoriteCountNotifier.value++; 
      }
    });
  }

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
            child: Column(
              children: [
                // 19. Tampilkan nilai dengan ValueListenableBuilder
                ValueListenableBuilder<int>(
                  valueListenable: favoriteCountNotifier,
                  builder: (context, value, child) {
                    return Text(
                      'Total Favorit (ValueNotifier): $value',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Text('$studentId - $studentName', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dummyCourses.length,
              itemBuilder: (context, index) {
                final course = dummyCourses[index];
                final isFav = _favoriteCourseCodes.contains(course['code']);

                return CourseCardReusable(
                  title: course['title']!,
                  code: course['code']!,
                  status: course['status']!,
                  isFavorite: isFav,
                  onFavoriteToggle: () => _toggleFavorite(course['code']!),
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
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CourseCardReusable({
    super.key,
    required this.title,
    required this.code,
    required this.status,
    required this.isFavorite,
    required this.onFavoriteToggle,
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
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}