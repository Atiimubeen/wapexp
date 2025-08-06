import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/pages/manage_achievements_page.dart';
import 'package:wapexp/admin_app/features/analytics/presentation/pages/analytics_page.dart';
import 'package:wapexp/admin_app/features/announcements/presentation/pages/manage_announcements_page.dart';
import 'package:wapexp/admin_app/features/auth/domain/entities/user_entity.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:wapexp/admin_app/features/auth/presentation/pages/login_page.dart';
import 'package:wapexp/admin_app/features/auth/presentation/widgets/dashboard_card.dart';
import 'package:wapexp/admin_app/features/courses/presentation/pages/manage_courses_page.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/pages/manage_sessions_page.dart';
import 'package:wapexp/admin_app/features/slider_images/presentation/pages/manage_slider_images_page.dart';

class AdminHomePage extends StatelessWidget {
  final UserEntity user;
  const AdminHomePage({super.key, required this.user});

  void _navigateToPage(BuildContext context, String title) {
    Widget page;
    switch (title) {
      case 'Manage Courses':
        page = const ManageCoursesPage();
        break;
      case 'Manage Achievements':
        page = const ManageAchievementsPage();
        break;
      case 'Manage Sessions':
        page = const ManageSessionsPage();
        break;
      case 'Slider Images':
        page = const ManageSliderImagesPage();
        break;
      case 'Announcements':
        page = const ManageAnnouncementsPage();
        break;
      case 'User Analytics':
        page = const AnalyticsPage();
        break;
      default:
        return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final List<Map<String, dynamic>> dashboardItems = [
      {'icon': Icons.school_outlined, 'title': 'Manage Courses'},
      {'icon': Icons.emoji_events_outlined, 'title': 'Manage Achievements'},
      {'icon': Icons.slideshow_outlined, 'title': 'Manage Sessions'},
      {'icon': Icons.image_outlined, 'title': 'Slider Images'},
      {'icon': Icons.campaign_outlined, 'title': 'Announcements'},
      {'icon': Icons.analytics_outlined, 'title': 'User Analytics'},
    ];

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // Navigate to login page and remove all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              tooltip: 'Log Out',
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogOutButtonPressed());
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              'Welcome back,',
              style: textTheme.titleLarge?.copyWith(color: Colors.grey),
            ),
            Text(
              user.name,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your application content from here.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 48),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dashboardItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final item = dashboardItems[index];
                return DashboardCard(
                  icon: item['icon'],
                  title: item['title'],
                  onTap: () {
                    _navigateToPage(context, item['title']);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
