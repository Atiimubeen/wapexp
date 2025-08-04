import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:wapexp/user_app/features/about_us/presentation/pages/about_us_page.dart';
import 'package:wapexp/user_app/features/achievements/presentation/pages/user_achievements_list_page.dart';
import 'package:wapexp/user_app/features/blogs/presentation/pages/blogs_page.dart'; // <-- Naya import
import 'package:wapexp/user_app/features/courses/presentation/pages/user_courses_list_page.dart';
import 'package:wapexp/user_app/features/sessions/presentation/pages/user_sessions_list_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String userName = "Guest";
    String userEmail = "Login to see details";
    String? userImageUrl;

    if (authState is Authenticated) {
      userName = authState.user.name;
      userEmail = authState.user.email;
      userImageUrl = authState.user.imageUrl;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundImage: userImageUrl != null
                  ? NetworkImage(userImageUrl)
                  : null,
              child: userImageUrl == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          _buildDrawerItem(
            context,
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () => Navigator.of(context).pop(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.school_outlined,
            title: 'Our Courses',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UserCoursesListPage()),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.emoji_events_outlined,
            title: 'Our Achievements',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const UserAchievementsListPage(),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.slideshow_outlined,
            title: 'Our Sessions',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UserSessionsListPage()),
            ),
          ),
          // **NAYA DRAWER ITEM**
          _buildDrawerItem(
            context,
            icon: Icons.article_outlined,
            title: 'Blogs',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const BlogsPage())),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AboutUsPage())),
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text(
              'Connect With Us',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.facebook,
            title: 'Facebook',
            onTap: () =>
                _launchURL('https://www.facebook.com/Wapexp.Institute.of.IT'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.camera_alt_outlined,
            title: 'Instagram',
            onTap: () =>
                _launchURL('https://www.instagram.com/wapexpinstitute'),
          ),
          // **NAYA DRAWER ITEM**
          _buildDrawerItem(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'WhatsApp',
            onTap: () => _launchURL('https://wa.me/+923269909794'),
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              context.read<AuthBloc>().add(LogOutButtonPressed());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      onTap: onTap,
    );
  }
}
