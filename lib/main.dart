import 'package:flutter/material.dart';

// --- IDENTITAS MAHASISWA ---
const String studentName = 'Febrian';
const String studentId = '2415051009';

void main() {
  runApp(const CourseExplorerApp());
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
      home: const CoursesPage(), // Langsung ke CoursesPage untuk tes Tahap 2
    );
  }
}

// ----------------------------------------------------
// TAHAP 2: PARENT WIDGET YANG MEMILIKI STATE (State Ownership)
// ----------------------------------------------------
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  // 9. Gunakan satu nilai favorites pada parent.
  final List<String> _favoriteCourseCodes = [];

  final List<Map<String, String>> dummyCourses = [
    {'title': 'Pemrograman Mobile', 'code': 'MOB04', 'status': 'Active'},
    {'title': 'Pemrograman Web', 'code': 'WEB05', 'status': 'Active'},
    {'title': 'Jaringan Komputer', 'code': 'NET06', 'status': 'Done'},
  ];

  // 11. Tambahkan callback dari child ke parent untuk mengubah favorites.
  void _toggleFavorite(String courseCode) {
    setState(() {
      if (_favoriteCourseCodes.contains(courseCode)) {
        _favoriteCourseCodes.remove(courseCode);
      } else {
        _favoriteCourseCodes.add(courseCode);
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
          // Menampilkan Summary (Berapa yang di-favoritkan)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo.shade50,
            width: double.infinity,
            child: Text(
              'Total Favorit: ${_favoriteCourseCodes.length}\n$studentId - $studentName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dummyCourses.length,
              itemBuilder: (context, index) {
                final course = dummyCourses[index];
                final isFav = _favoriteCourseCodes.contains(course['code']);

                // 10. Teruskan nilai ke dua child menggunakan constructor.
                return CourseCardReusable(
                  title: course['title']!,
                  code: course['code']!,
                  status: course['status']!,
                  isFavorite: isFav, // Oper data (Prop Drilling)
                  onFavoriteToggle: () => _toggleFavorite(course['code']!), // Oper fungsi callback (Prop Drilling)
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TAHAP 2: CHILD WIDGET MENERIMA STATE MELALUI CONSTRUCTOR
// ----------------------------------------------------
class CourseCardReusable extends StatelessWidget {
  final String title;
  final String code;
  final String status;
  // 12. Catat bagian kode yang mulai berulang (Menerima parameter yang diteruskan dari Parent)
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
          // Memanggil fungsi callback yang diberikan oleh Parent
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}