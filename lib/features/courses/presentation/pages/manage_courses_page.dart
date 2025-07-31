import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/courses/domain/entities/course_entity.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_bloc.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_event.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_state.dart';
import 'package:wapexp/features/courses/presentation/pages/add_edit_course_page.dart';
import 'package:wapexp/features/courses/presentation/widgets/course_list_tile.dart';
import 'package:wapexp/injection_container.dart';

class ManageCoursesPage extends StatelessWidget {
  const ManageCoursesPage({super.key});

  void _showDeleteConfirmation(BuildContext context, CourseEntity course) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete "${course.name}"? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                // Yahan hum 'context' istemal kar rahe hain jo 'showDialog' se pehle ka hai
                context.read<CourseBloc>().add(
                  DeleteCourseButtonPressed(
                    courseId: course.id,
                    imageUrl: course.imageUrl,
                  ),
                );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddEditPage(BuildContext context, {CourseEntity? course}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<CourseBloc>(context),
          child: AddEditCoursePage(course: course),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseBloc>()..add(LoadCourses()),
      // **FIX #2: BUILDER WIDGET**
      // Yeh Builder widget ek naya context (innerContext) banata hai jo BlocProvider ke neeche hota hai.
      // Is se crash ka masla hal ho jayega.
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: AppBar(title: const Text('Manage Courses')),
            body: BlocConsumer<CourseBloc, CourseState>(
              // **FIX #1: BUILDWHEN**
              // Yeh BLoC ko batata hai ke UI ko sirf in states ke liye dobara banao.
              // 'CourseActionSuccess' par UI dobara nahi banega, sirf message nazar aayega.
              buildWhen: (previous, current) =>
                  current is CourseLoading ||
                  current is CoursesLoaded ||
                  current is CourseFailure,
              listener: (context, state) {
                if (state is CourseActionSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                } else if (state is CourseFailure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
              },
              builder: (context, state) {
                if (state is CoursesLoaded) {
                  if (state.courses.isEmpty) {
                    return const Center(
                      child: Text('No courses found. Add one!'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.courses.length,
                    itemBuilder: (context, index) {
                      final course = state.courses[index];
                      return CourseListTile(
                        course: course,
                        // Hum 'innerContext' istemal kar rahe hain jo BLoC ko dhoond sakta hai
                        onEdit: () => _navigateToAddEditPage(
                          innerContext,
                          course: course,
                        ),
                        onDelete: () =>
                            _showDeleteConfirmation(innerContext, course),
                      );
                    },
                  );
                }
                // CourseInitial, CourseLoading, aur CourseFailure ke liye
                return const Center(child: CircularProgressIndicator());
              },
            ),
            floatingActionButton: FloatingActionButton(
              // Hum 'innerContext' istemal kar rahe hain
              onPressed: () => _navigateToAddEditPage(innerContext),
              tooltip: 'Add New Course',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
