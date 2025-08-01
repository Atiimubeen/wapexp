import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/features/announcements/domain/entities/announcement_entity.dart';

class AnnouncementListTile extends StatelessWidget {
  final AnnouncementEntity announcement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const AnnouncementListTile({
    super.key,
    required this.announcement,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          announcement.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat('MMM d, yyyy').format(announcement.date)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit')
              onEdit();
            else if (value == 'delete')
              onDelete();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
