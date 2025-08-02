import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/user_app/features/courses/presentation/bloc/user_courses_bloc.dart';
import 'package:wapexp/user_app/features/courses/presentation/bloc/user_courses_event.dart';
import 'package:wapexp/user_app/features/courses/presentation/bloc/user_courses_state.dart';
import 'package:wapexp/user_app/features/courses/presentation/pages/course_detail_page.dart';
import 'package:wapexp/user_app/features/courses/presentation/widgets/user_course_card.dart';
import 'package:wapexp/user_app/user_injection_container.dart';

class UserCoursesListPage extends StatelessWidget {
  const UserCoursesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserCoursesBloc>()..add(LoadUserCourses()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Our Courses')),
        body: BlocBuilder<UserCoursesBloc, UserCoursesState>(
          builder: (context, state) {
            if (state is UserCoursesLoading || state is UserCoursesInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserCoursesFailure) {
              return Center(child: Text(state.message));
            }
            if (state is UserCoursesLoaded) {
              if (state.courses.isEmpty) {
                return const Center(
                  child: Text('No courses available at the moment.'),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  final course = state.courses[index];
                  return UserCourseCard(
                    course: course,
                    onTap: () {
                      // **NAYI LOGIC**
                      // 1. View count barhane ke liye event bhejo
                      context.read<UserCoursesBloc>().add(
                        CourseCardTapped(courseId: course.id),
                      );
                      // 2. Detail page par navigate karo
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CourseDetailPage(course: course),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
