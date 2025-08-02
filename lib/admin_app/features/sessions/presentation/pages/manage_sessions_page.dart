import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/bloc/session_bloc.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/bloc/session_event.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/bloc/session_state.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/pages/add_edit_session_page.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/widgets/session_list_tile.dart';
import 'package:wapexp/admin_app/admin_injection_container.dart';

class ManageSessionsPage extends StatelessWidget {
  const ManageSessionsPage({super.key});

  void _showDeleteConfirmation(BuildContext context, SessionEntity session) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${session.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              context.read<SessionBloc>().add(
                DeleteSessionButtonPressed(session: session),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddEditPage(BuildContext context, {SessionEntity? session}) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<SessionBloc>(context),
              child: AddEditSessionPage(session: session),
            ),
          ),
        )
        .then((_) => context.read<SessionBloc>().add(LoadSessions()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SessionBloc>()..add(LoadSessions()),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: AppBar(title: const Text('Manage Sessions')),
            body: BlocConsumer<SessionBloc, SessionState>(
              buildWhen: (p, c) => c is! SessionActionSuccess,
              listener: (context, state) {
                if (state is SessionActionSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                  context.read<SessionBloc>().add(LoadSessions());
                }
              },
              builder: (context, state) {
                if (state is SessionLoading || state is SessionInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SessionFailure) {
                  return Center(child: Text(state.message));
                }
                if (state is SessionsLoaded) {
                  if (state.sessions.isEmpty)
                    return const Center(child: Text('No sessions found.'));
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.sessions.length,
                    itemBuilder: (context, index) {
                      final session = state.sessions[index];
                      return SessionListTile(
                        session: session,
                        onEdit: () => _navigateToAddEditPage(
                          innerContext,
                          session: session,
                        ),
                        onDelete: () =>
                            _showDeleteConfirmation(innerContext, session),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _navigateToAddEditPage(innerContext),
              tooltip: 'Add New Session',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
