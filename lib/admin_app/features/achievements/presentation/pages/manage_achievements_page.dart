import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/achievements/domain/entities/achievement_entity.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/bloc/achievement_bloc.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/bloc/achievement_event.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/bloc/achievement_state.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/pages/add_edit_achievement_page.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/widgets/achievement_list_tile.dart';
import 'package:wapexp/admin_app/injection_container.dart';

class ManageAchievementsPage extends StatelessWidget {
  const ManageAchievementsPage({super.key});

  void _showDeleteConfirmation(
    BuildContext context,
    AchievementEntity achievement,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete "${achievement.name}"? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                context.read<AchievementBloc>().add(
                  DeleteAchievementButtonPressed(achievement: achievement),
                );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddEditPage(
    BuildContext context, {
    AchievementEntity? achievement,
  }) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<AchievementBloc>(context),
              child: AddEditAchievementPage(achievement: achievement),
            ),
          ),
        )
        .then((_) {
          // Jab Add/Edit page se wapas aayein, to list ko refresh karo.
          context.read<AchievementBloc>().add(LoadAchievements());
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AchievementBloc>()..add(LoadAchievements()),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: AppBar(title: const Text('Manage Achievements')),
            body: BlocConsumer<AchievementBloc, AchievementState>(
              // UI ko sirf in states ke liye dobara banao.
              buildWhen: (previous, current) =>
                  current is AchievementLoading ||
                  current is AchievementsLoaded ||
                  current is AchievementFailure,
              listener: (context, state) {
                // Jab bhi koi action kamyab ho, message dikhao aur list ko refresh karo.
                if (state is AchievementActionSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                  context.read<AchievementBloc>().add(LoadAchievements());
                } else if (state is AchievementFailure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
              },
              builder: (context, state) {
                if (state is AchievementsLoaded) {
                  if (state.achievements.isEmpty) {
                    return const Center(
                      child: Text('No achievements found. Add one!'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.achievements.length,
                    itemBuilder: (context, index) {
                      final achievement = state.achievements[index];
                      return AchievementListTile(
                        achievement: achievement,
                        onEdit: () => _navigateToAddEditPage(
                          innerContext,
                          achievement: achievement,
                        ),
                        onDelete: () =>
                            _showDeleteConfirmation(innerContext, achievement),
                      );
                    },
                  );
                }
                // Initial, Loading, aur Failure states ke liye
                return const Center(child: CircularProgressIndicator());
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _navigateToAddEditPage(innerContext),
              tooltip: 'Add New Achievement',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
