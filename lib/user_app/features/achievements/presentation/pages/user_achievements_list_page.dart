import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/user_app/features/achievements/presentation/bloc/user_achievements_bloc.dart';
import 'package:wapexp/user_app/features/achievements/presentation/bloc/user_achievements_event.dart';
import 'package:wapexp/user_app/features/achievements/presentation/bloc/user_achievements_state.dart';
import 'package:wapexp/user_app/features/achievements/presentation/pages/achievement_detail_page.dart';
import 'package:wapexp/user_app/features/achievements/presentation/widgets/user_achievement_card.dart';
import 'package:wapexp/user_app/user_injection_container.dart';

class UserAchievementsListPage extends StatelessWidget {
  const UserAchievementsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<UserAchievementsBloc>()..add(LoadUserAchievements()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Our Achievements')),
        body: BlocBuilder<UserAchievementsBloc, UserAchievementsState>(
          builder: (context, state) {
            if (state is UserAchievementsLoading ||
                state is UserAchievementsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserAchievementsFailure) {
              return Center(child: Text(state.message));
            }
            if (state is UserAchievementsLoaded) {
              if (state.achievements.isEmpty) {
                return const Center(
                  child: Text('No achievements to show yet.'),
                );
              }
              // **THE FIX IS HERE: RefreshIndicator**
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserAchievementsBloc>().add(
                    LoadUserAchievements(),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = state.achievements[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: UserAchievementCard(
                        achievement: achievement,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AchievementDetailPage(
                                achievement: achievement,
                              ),
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
