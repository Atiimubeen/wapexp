import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';

class SessionListTile extends StatelessWidget {
  final SessionEntity session;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const SessionListTile({
    super.key,
    required this.session,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            session.coverImageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          session.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Date: ${DateFormat('MMM d, yyyy').format(session.date)}',
        ),
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
