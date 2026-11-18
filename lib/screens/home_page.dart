import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import '../widgets/role_guard.dart';
import '../main.dart';
import 'add_course_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseState>();

    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final p = snap.data;
        if (snap.hasError || p == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course Explorer v2'),
              actions: [
                IconButton(
                  tooltip: 'Logout',
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
            ),
            body: const Center(child: Text('Gagal memuat profil pengguna')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Course Explorer (${p.role})'),
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: Column(
            children: [
              // Banner Identitas Mahasiswa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.blue.shade50,
                child: const Text(
                  '$studentId • $studentName',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Kartu Informasi Profil & Role Pengguna
              Card(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(p.name.isEmpty ? p.email : p.name),
                      subtitle: Text('${p.email} • ${p.role}'),
                      trailing: Chip(
                        label: Text(
                          p.role.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Menu khusus role Owner / Admin
                    if (p.isOwner || p.isAdmin) ...[
                      const Divider(height: 1),
                      const ListTile(
                        dense: true,
                        leading: Icon(Icons.manage_accounts, color: Colors.blue),
                        title: Text('Akses Pengelola Course (Owner/Admin)'),
                        subtitle: Text('Dapat menambahkan dan mengelola data course'),
                      ),
                    ],
                    // Menu khusus role Admin
                    if (p.isAdmin) ...[
                      const Divider(height: 1),
                      const ListTile(
                        dense: true,
                        leading: Icon(Icons.admin_panel_settings, color: Colors.orange),
                        title: Text('Kelola Data Pengguna (Admin)'),
                      ),
                    ],
                  ],
                ),
              ),

              // Daftar Mata Kuliah
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.error != null) {
                      return ErrorView(
                        message: provider.error!,
                        onRetry: provider.loadCourses,
                      );
                    }
                    if (provider.courses.isEmpty) {
                      return const Center(child: Text('Data course belum tersedia'));
                    }
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

          // Tombol Tambah Course (+) hanya tampil untuk role 'owner' atau 'admin'
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddCoursePage(),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}