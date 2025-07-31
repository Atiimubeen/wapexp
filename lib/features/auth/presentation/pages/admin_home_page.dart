import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/auth/domain/entities/user_entity.dart';
import 'package:wapexp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/features/auth/presentation/bloc/auth_event.dart';
import 'package:wapexp/features/auth/presentation/widgets/dashboard_card.dart';
import 'package:wapexp/features/courses/presentation/pages/manage_courses_page.dart';

class AdminHomePage extends StatelessWidget {
  final UserEntity user;
  const AdminHomePage({super.key, required this.user});

  // Helper function to handle navigation
  void _navigateToPage(BuildContext context, String title) {
    Widget page;
    switch (title) {
      case 'Manage Courses':
        page = const ManageCoursesPage();
        break;
      // TODO: Add cases for other pages
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title page coming soon!')));
        return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dashboardItems = [
      {'icon': Icons.school_outlined, 'title': 'Manage Courses'},
      {'icon': Icons.emoji_events_outlined, 'title': 'Manage Achievements'},
      {'icon': Icons.slideshow_outlined, 'title': 'Manage Sessions'},
      {'icon': Icons.image_outlined, 'title': 'Slider Images'},
      {'icon': Icons.campaign_outlined, 'title': 'Announcements'},
      {'icon': Icons.analytics_outlined, 'title': 'User Analytics'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Log Out',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const LogOutButtonPressed());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.name}!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your application content from here.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: dashboardItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
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
            ),
          ],
        ),
      ),
    );
  }
}
