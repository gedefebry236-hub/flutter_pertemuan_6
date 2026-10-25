import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import '../main.dart'; // Import main.dart untuk memanggil fungsi fetchCourses()

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Scaffold(body: Center(child: Text('Daftar Semua Courses', style: TextStyle(fontSize: 20)))),
    const FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Tampilan Layar Kecil (Mobile)
          return Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() => _selectedIndex = index);
                // Uji coba pemanggilan API saat tab diklik (Tahap 2)
                fetchCourses().catchError((e) => debugPrint('Error: $e'));
              },
              selectedItemColor: Colors.blue.shade700,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
              ],
            ),
          );
        } else {
          // Tampilan Layar Lebar (Web/Tablet)
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                    // Uji coba pemanggilan API saat tab diklik (Tahap 2)
                    fetchCourses().catchError((e) => debugPrint('Error: $e'));
                  },
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: IconThemeData(color: Colors.blue.shade700),
                  selectedLabelTextStyle: TextStyle(color: Colors.blue.shade700),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.book), label: Text('Courses')),
                    NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
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