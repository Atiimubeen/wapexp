import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/features/achievements/domain/entities/achievement_entity.dart';

class AchievementListTile extends StatelessWidget {
  final AchievementEntity achievement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const AchievementListTile({
    super.key,
    required this.achievement,
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
            achievement.coverImageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          achievement.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Date: ${DateFormat('MMM d, yyyy').format(achievement.date)}',
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
