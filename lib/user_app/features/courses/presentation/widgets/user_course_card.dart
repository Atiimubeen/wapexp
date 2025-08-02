import 'package:flutter/material.dart';
import 'package:wapexp/admin_app/features/courses/domain/entities/course_entity.dart';

class UserCourseCard extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback onTap;

  const UserCourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      clipBehavior:
          Clip.antiAlias, // Image ko card ke shape mein clip karne ke liye
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag:
                      'course_image_${course.id}', // Hero animation ke liye tag
                  child: Image.network(
                    course.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          height: 120,
                          child: Icon(
                            Icons.school_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
                // Price ke liye ek khubsurat sa tag
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Rs. ${course.price}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: colors.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.duration,
                        style: TextStyle(
                          color: colors.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
