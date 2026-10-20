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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const ResponsiveShell(),
    );
  }
}

// ----------------------------------------------------
// 1. RESPONSIVE SHELL (Navigasi Utama)
// ----------------------------------------------------
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  // Local State untuk navigasi
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CoursesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Layout Compact (HP)
          return Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        } else {
          // Layout Expanded (Web / Tablet)
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.school), label: Text('Courses')),
                    NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          );
        }
      },
    );
  }
}

// ----------------------------------------------------
// 2. HALAMAN HOME & PROFILE
// ----------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Selamat Datang di Course Explorer', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('$studentId - $studentName', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Text(
          'Profile Page\n$studentId - $studentName',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 3. HALAMAN DAFTAR COURSES
// ----------------------------------------------------
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy Sementara
    final List<Map<String, String>> dummyCourses = [
      {'title': 'Pemrograman Mobile', 'code': 'MOB04', 'status': 'Active'},
      {'title': 'Pemrograman Web', 'code': 'WEB05', 'status': 'Active'},
      {'title': 'Jaringan Komputer', 'code': 'NET06', 'status': 'Done'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Courses')),
      body: ListView.builder(
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
    );
  }
}

// ----------------------------------------------------
// 4. WIDGET KARTU (Implementasi Local State - TAHAP 1)
// ----------------------------------------------------
class CourseCardReusable extends StatefulWidget {
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
  State<CourseCardReusable> createState() => _CourseCardReusableState();
}

class _CourseCardReusableState extends State<CourseCardReusable> {
  // === LOCAL STATE TAHAP 1 ===
  bool isFavorite = false;

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
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${widget.code} • ${widget.status}'),
        
        // Ikon Favorite dengan State
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            // Mengubah Local State
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
        
        onTap: () {
          // Pindah ke Detail Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(title: widget.title, code: widget.code, status: widget.status),
            ),
          );
        },
      ),
    );
  }
}

// ----------------------------------------------------
// 5. HALAMAN DETAIL (Untuk Navigasi)
// ----------------------------------------------------
class CourseDetailPage extends StatelessWidget {
  final String title;
  final String code;
  final String status;

  const CourseDetailPage({super.key, required this.title, required this.code, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Kode: $code', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: $status', style: const TextStyle(fontSize: 16)),
            const Spacer(),
            const Center(child: Text('$studentId - $studentName', style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}