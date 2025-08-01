import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:wapexp/admin_app/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:wapexp/admin_app/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:wapexp/admin_app/features/analytics/presentation/widgets/info_card.dart';
import 'package:wapexp/admin_app/features/courses/presentation/widgets/course_list_tile.dart';
import 'package:wapexp/admin_app/features/courses/presentation/widgets/section_header.dart';
import 'package:wapexp/admin_app/injection_container.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AnalyticsBloc>()..add(LoadAnalyticsData()),
      child: Scaffold(
        appBar: AppBar(title: const Text('User Analytics')),
        body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading || state is AnalyticsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AnalyticsFailure) {
              return Center(child: Text(state.message));
            }
            if (state is AnalyticsLoaded) {
              final data = state.data;
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  InfoCard(
                    title: 'Total Registered Users',
                    value: data.totalUsers.toString(),
                    icon: Icons.people_outline,
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 16),

                  // Aap yahan doosre stats ke liye InfoCard add kar sakte hain
                  const SectionHeader(title: 'Top 5 Viewed Courses'),
                  if (data.topCourses.isEmpty)
                    const Text('No course data available yet.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.topCourses.length,
                      itemBuilder: (context, index) {
                        final course = data.topCourses[index];
                        // Hum CourseListTile ko reuse kar rahe hain, lekin behtar hai
                        // ke analytics ke liye alag widget banayein.
                        return CourseListTile(
                          course: course,
                          onEdit: () {}, // Analytics page par edit nahi hoga
                          onDelete:
                              () {}, // Analytics page par delete nahi hoga
                        );
                      },
                    ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
