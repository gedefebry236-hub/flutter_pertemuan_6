import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/main_screen.dart';

const String studentName = 'Febrian';
const String studentId = '2415051009';

// Poin 13: Buat konstanta apiUrl sesuai endpoint latihan
const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

// Poin 14: Fungsi asynchronous sementara untuk memanggil GET
Future<List<dynamic>> fetchCourses() async {
  debugPrint('Mengambil data dari API...');
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    // Poin 15: Tampilkan jumlah item pada debugPrint
    debugPrint('Berhasil! Jumlah item dari API: ${data.length}');
    return data;
  }

  throw Exception('HTTP ${response.statusCode}');
}

void main() {
  final courseService = CourseService();
  final courseRepository = CourseRepository(courseService);

  runApp(
    ChangeNotifierProvider(
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
      title: 'Course Explorer v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}