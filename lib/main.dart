import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/course_api_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/main_screen.dart';

const String studentName = 'Febrian';
const String studentId = '2415051009';

void main() {
  // Inisialisasi API Service dengan base URL JSONPlaceholder
  final apiService = CourseApiService('https://jsonplaceholder.typicode.com');
  final courseRepository = CourseRepository(apiService);

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