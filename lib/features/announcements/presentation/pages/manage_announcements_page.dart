import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/announcements/domain/entities/announcement_entity.dart';
import 'package:wapexp/features/announcements/presentation/bloc/announcement_bloc.dart';
import 'package:wapexp/features/announcements/presentation/bloc/announcement_event.dart';
import 'package:wapexp/features/announcements/presentation/bloc/announcement_state.dart';
import 'package:wapexp/features/announcements/presentation/pages/add_edit_announcement_page.dart';
import 'package:wapexp/features/announcements/presentation/widgets/announcement_list_tile.dart';
import 'package:wapexp/injection_container.dart';

class ManageAnnouncementsPage extends StatelessWidget {
  const ManageAnnouncementsPage({super.key});

  void _showDeleteConfirmation(
    BuildContext context,
    AnnouncementEntity announcement,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to delete "${announcement.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              context.read<AnnouncementBloc>().add(
                DeleteAnnouncementButtonPressed(id: announcement.id),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddEditPage(
    BuildContext context, {
    AnnouncementEntity? announcement,
  }) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<AnnouncementBloc>(context),
              child: AddEditAnnouncementPage(announcement: announcement),
            ),
          ),
        )
        .then((_) => context.read<AnnouncementBloc>().add(LoadAnnouncements()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AnnouncementBloc>()..add(LoadAnnouncements()),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: AppBar(title: const Text('Manage Announcements')),
            body: BlocConsumer<AnnouncementBloc, AnnouncementState>(
              buildWhen: (p, c) => c is! AnnouncementActionSuccess,
              listener: (context, state) {
                if (state is AnnouncementActionSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                  context.read<AnnouncementBloc>().add(LoadAnnouncements());
                }
              },
              builder: (context, state) {
                if (state is AnnouncementLoading ||
                    state is AnnouncementInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AnnouncementFailure) {
                  return Center(child: Text(state.message));
                }
                if (state is AnnouncementsLoaded) {
                  if (state.announcements.isEmpty)
                    return const Center(child: Text('No announcements found.'));
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = state.announcements[index];
                      return AnnouncementListTile(
                        announcement: announcement,
                        onEdit: () => _navigateToAddEditPage(
                          innerContext,
                          announcement: announcement,
                        ),
                        onDelete: () =>
                            _showDeleteConfirmation(innerContext, announcement),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _navigateToAddEditPage(innerContext),
              tooltip: 'Add New Announcement',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
