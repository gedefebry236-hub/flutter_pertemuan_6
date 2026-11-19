import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  Future<void> _showEditDialog(BuildContext context) async {
    final titleC = TextEditingController(text: course.title);
    final creditsC = TextEditingController(text: course.credits.toString());
    final statuses = <String>{
      'planned',
      'ongoing',
      'completed',
      course.status,
    }.toList();
    String selectedStatus = course.status;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text('Edit ${course.code}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleC,
                      decoration: const InputDecoration(labelText: 'Nama Course'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: creditsC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'SKS'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: statuses
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedStatus = v);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () async {
                    final newTitle = titleC.text.trim();
                    if (newTitle.isEmpty) return;

                    final updated = Course(
                      id: course.id,
                      ownerId: course.ownerId,
                      code: course.code,
                      title: newTitle,
                      credits:
                          int.tryParse(creditsC.text.trim()) ?? course.credits,
                      status: selectedStatus,
                    );

                    Navigator.pop(dialogContext);
                    final ok = await context
                        .read<CourseState>()
                        .editCourse(course.code, updated);

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok
                              ? 'Course berhasil diperbarui'
                              : (context.read<CourseState>().error ??
                                  'Gagal memperbarui course'),
                        ),
                      ),
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Course'),
          content: Text('Yakin ingin menghapus "${course.title}" (${course.code})?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext);
                final ok = await context
                    .read<CourseState>()
                    .deleteCourse(course.code);

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? 'Course berhasil dihapus'
                          : (context.read<CourseState>().error ??
                              'Gagal menghapus course'),
                    ),
                  ),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CourseState>();
    final isFav = state.isFavorite(course.code);
    final myId = Supabase.instance.client.auth.currentUser?.id;
    final isMine = course.ownerId != null && course.ownerId == myId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.book, color: Colors.blue),
        ),
        title: Text(
          course.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${course.code} • ${course.credits} SKS • ${course.status}${isMine ? ' • Milik Anda' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Favorit',
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () =>
                  context.read<CourseState>().toggleFavorite(course.code),
            ),
            if (isMine) ...[
              IconButton(
                tooltip: 'Edit Course',
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context),
              ),
              IconButton(
                tooltip: 'Hapus Course',
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailPage(course: course),
            ),
          );
        },
      ),
    );
  }
}