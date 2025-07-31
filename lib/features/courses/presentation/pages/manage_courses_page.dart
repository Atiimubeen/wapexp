import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_bloc.dart';
import 'package:wapexp/features/courses/presentation/pages/add_edit_course_page.dart';
import 'package:wapexp/injection_container.dart';

class ManageCoursesPage extends StatelessWidget {
  const ManageCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Courses')),
      body: const Center(
        child: Text(
          'Courses list will appear here.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Jab hum AddEditCoursePage par jayein, to usko CourseBloc provide karein.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => getIt<CourseBloc>(),
                child: const AddEditCoursePage(),
              ),
            ),
          );
        },
        tooltip: 'Add New Course',
        child: const Icon(Icons.add),
      ),
    );
  }
}
