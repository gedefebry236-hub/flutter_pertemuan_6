import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Banner Identitas (Wajib)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              '$studentId • $studentName',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          Expanded(
            child: Builder(
              builder: (context) {
                // State 1: Loading
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // State 2: Error
                if (provider.error != null) {
                  return ErrorView(
                    message: provider.error!,
                    onRetry: provider.loadCourses,
                  );
                }

                // State 3: Empty (Kosong)
                if (provider.courses.isEmpty) {
                  return const Center(child: Text('Data course belum tersedia'));
                }

                // State 4: Success (Data tersedia)
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    return CourseCard(course: course);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}