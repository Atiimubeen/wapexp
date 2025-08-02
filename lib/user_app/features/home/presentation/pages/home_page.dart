import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:wapexp/admin_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:wapexp/user_app/features/about_us/presentation/pages/about_us_page.dart';
import 'package:wapexp/user_app/features/achievements/presentation/pages/user_achievements_list_page.dart';
import 'package:wapexp/user_app/features/courses/presentation/pages/user_courses_list_page.dart';
import 'package:wapexp/user_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:wapexp/user_app/features/home/presentation/bloc/home_event.dart';
import 'package:wapexp/user_app/features/home/presentation/bloc/home_state.dart';
import 'package:wapexp/user_app/features/sessions/presentation/pages/user_sessions_list_page.dart';
import 'package:wapexp/user_app/user_injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthBloc se user ki details haasil karna
    final authState = context.watch<AuthBloc>().state;
    String userName = "Guest";
    String userEmail = "";
    String? userImageUrl;

    if (authState is Authenticated) {
      userName = authState.user.name;
      userEmail = authState.user.email;
      userImageUrl = authState.user.imageUrl;
    }

    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(LoadHomeData()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Wapexp'), centerTitle: true),
        // **NAYA DRAWER**
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: userImageUrl != null
                      ? NetworkImage(userImageUrl)
                      : null,
                  child: userImageUrl == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // Logout event bhejna
                  context.read<AuthBloc>().add(LogOutButtonPressed());
                  Navigator.of(context).pop(); // Drawer ko band karna
                },
              ),
            ],
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeFailure) {
              return Center(child: Text(state.message));
            }
            if (state is HomeLoaded) {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildImageSlider(state),
                  const SizedBox(height: 24),
                  _buildCategoriesGrid(context),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildImageSlider(HomeLoaded state) {
    if (state.sliderImages.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text('No promotional images available.')),
      );
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
      items: state.sliderImages.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(image.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildCategoryCard(
          'Our Courses',
          Icons.school_outlined,
          Colors.blue,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UserCoursesListPage()),
            );
          },
        ),
        _buildCategoryCard(
          'Our Achievements',
          Icons.emoji_events_outlined,
          Colors.orange,
          () {
            // <-- Naya onTap function
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const UserAchievementsListPage(),
              ),
            );
          },
        ),
        _buildCategoryCard(
          'Our Sessions',
          Icons.slideshow_outlined,
          Colors.purple,
          () {
            // <-- Naya onTap function
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UserSessionsListPage()),
            );
          },
        ),
        _buildCategoryCard('About Us', Icons.info_outline, Colors.teal, () {
          // <-- Naya onTap function
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AboutUsPage()));
        }),
      ],
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color.withOpacity(0.8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
