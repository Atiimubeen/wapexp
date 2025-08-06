// home_page.dart (Final Code with Themed Header)

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
        appBar: AppBar(title: const Text('Wapexp'), centerTitle: true),
        drawer: const AppDrawer(),
        body: BlocConsumer<HomeBloc, HomeState>(
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
                    _buildHeader(context), // <-- context pass karein
                    const SizedBox(height: 20),
                    _buildImageSlider(state),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 16),
                      child: Text(
                        'Categories',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
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
    );
  }

  // **THE FIX IS HERE:** Ab yeh context se theme-aware colors istemal kar raha hai
  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
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
                    color: textTheme.bodyLarge?.color, // <-- Theme se color
                  ),
                ),
                Text(
                  'to learn something new!',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: textTheme.bodyMedium?.color?.withOpacity(
                      0.7,
                    ), // <-- Theme se color
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 50,
            width: 50,
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
          color: Theme.of(context).colorScheme.surface,
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
