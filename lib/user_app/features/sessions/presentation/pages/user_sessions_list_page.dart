// File: lib/user_app/features/sessions/presentation/pages/user_sessions_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/user_app/features/sessions/presentation/bloc/user_sessions_bloc.dart';
import 'package:wapexp/user_app/features/sessions/presentation/bloc/user_sessions_event.dart';
import 'package:wapexp/user_app/features/sessions/presentation/bloc/user_sessions_state.dart';
import 'package:wapexp/user_app/features/sessions/presentation/pages/session_detail_page.dart';
import 'package:wapexp/user_app/features/sessions/presentation/widgets/user_session_card.dart';
import 'package:wapexp/user_app/user_injection_container.dart';

class UserSessionsListPage extends StatelessWidget {
  const UserSessionsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserSessionsBloc>()..add(LoadUserSessions()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Our Sessions')),
        body: BlocBuilder<UserSessionsBloc, UserSessionsState>(
          builder: (context, state) {
            if (state is UserSessionsLoading || state is UserSessionsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserSessionsFailure) {
              return Center(child: Text(state.message));
            }
            if (state is UserSessionsLoaded) {
              if (state.sessions.isEmpty) {
                return const Center(child: Text('No sessions to show yet.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserSessionsBloc>().add(LoadUserSessions());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.sessions.length,
                  itemBuilder: (context, index) {
                    final session = state.sessions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: UserSessionCard(
                        session: session,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  SessionDetailPage(session: session),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
