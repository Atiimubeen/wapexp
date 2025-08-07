// Enhanced home_page.dart with Professional Background

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/user_app/features/about_us/presentation/pages/about_us_page.dart';
import 'package:wapexp/user_app/features/achievements/presentation/pages/user_achievements_list_page.dart';
import 'package:wapexp/user_app/features/courses/presentation/pages/user_courses_list_page.dart';
import 'package:wapexp/user_app/features/sessions/presentation/pages/user_sessions_list_page.dart';
import 'package:wapexp/user_app/presentation/bloc/home_bloc.dart';
import 'package:wapexp/user_app/presentation/bloc/home_event.dart';
import 'package:wapexp/user_app/presentation/bloc/home_state.dart';
import 'package:wapexp/user_app/presentation/widgets/app_drawer.dart';
import 'package:wapexp/user_app/user_injection_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static bool _announcementShown = false;

  void _showAnnouncementDialog(BuildContext context, HomeLoaded state) {
    if (state.latestAnnouncement != null && !_announcementShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _announcementShown = true;
          });
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.campaign,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text('Announcement'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.latestAnnouncement!.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'MMM d, yyyy',
                    ).format(state.latestAnnouncement!.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Divider(height: 24),
                  Text(state.latestAnnouncement!.description),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(LoadHomeData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wapexp'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white, // Green matching your logo
                  Colors.white,
                ],
              ),
            ),
          ),
        ),
        drawer: const AppDrawer(),
        // MAIN BACKGROUND ENHANCEMENT HERE
        body: Container(
          decoration: _buildBackgroundDecoration(context),
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeLoaded) {
                _showAnnouncementDialog(context, state);
              }
            },
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(LoadHomeData());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              if (state is HomeLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(LoadHomeData());
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 20),
                      _buildImageSlider(state),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 16),
                        child: Text(
                          'Categories',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(
                                  0xFF2E7D32,
                                ), // Dark green for contrast
                              ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      _buildCategoriesGrid(context),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // PROFESSIONAL BACKGROUND DECORATION
  BoxDecoration _buildBackgroundDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E1E1E),
            const Color(0xFF2D2D2D),
            const Color(0xFF1A4D1A), // Subtle green tint
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      );
    } else {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF8FDF8), // Very light green tint
            const Color(0xFFF0F8F0), // Slightly more green
            const Color(0xFFE8F5E8), // Light green at bottom
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today is a good day',
                  style: GoogleFonts.lato(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32), // Green matching brand
                  ),
                ),
                Text(
                  'to learn something new!',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              'assets/images/wapexplogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider(HomeLoaded state) {
    if (state.sliderImages.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No promotional images available.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
      items: state.sliderImages.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
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
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const UserCoursesListPage()),
          ),
        ),
        _buildCategoryCard(
          'Our Achievements',
          Icons.emoji_events_outlined,
          Colors.orange,
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const UserAchievementsListPage()),
          ),
        ),
        _buildCategoryCard(
          'Our Sessions',
          Icons.slideshow_outlined,
          Colors.purple,
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const UserSessionsListPage()),
          ),
        ),
        _buildCategoryCard(
          'About Us',
          Icons.info_outline,
          Colors.teal,
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AboutUsPage())),
        ),
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
      elevation: 6, // Increased elevation for better depth
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: color.withOpacity(0.3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.8), color.withOpacity(0.9)],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 48, color: Colors.white),
              ),
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
      ),
    );
  }
}
