import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_keys.dart';
import 'services/auth_service.dart';
import 'services/course_supabase_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/login_page.dart';
import 'screens/main_screen.dart';

// ==========================================
// 2415051009 - Febrian
// ==========================================
const String studentName = 'Febrian';
const String studentId = '2415051009';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase menggunakan publishableKey terbaru
  await Supabase.initialize(
    url: 'https://mcuzmvpsiifpefimdacl.supabase.co',
    publishableKey: 'sb_publishable_OLIHQHttIabPXNFw9OUaEg_RWCxhPH1',
  );

  // Opsional: mendengarkan perubahan status session secara global
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    debugPrint('Auth event: ${data.event}');
    if (data.event == AuthChangeEvent.signedOut) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  });

  // Menggunakan Supabase Service untuk Tahap 12
  final supabaseService = CourseSupabaseService();
  final courseRepository = CourseRepository(supabaseService);

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
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      // Check Session: jika sudah login masuk MainScreen, jika belum ke LoginPage
      home: AuthService.instance.isLoggedIn
          ? const MainScreen()
          : const LoginPage(),
    );
  }
}