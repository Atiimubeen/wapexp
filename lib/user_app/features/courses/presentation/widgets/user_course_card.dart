import 'package:flutter/material.dart';
import 'package:wapexp/admin_app/features/courses/domain/entities/course_entity.dart';

class UserCourseCard extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback onTap;

  const UserCourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // **ASAL LOGIC YAHAN HAI**
    // Check karo ke discount valid hai ya nahi
    final bool hasValidDiscount =
        course.discountedPrice != null &&
        course.discountedPrice!.isNotEmpty &&
        course.offerEndDate != null &&
        course.offerEndDate!.isAfter(DateTime.now());

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Hero(
                  tag: 'course_image_${course.id}',
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
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    // Agar discount hai to discounted price dikhao, warna original
                    hasValidDiscount
                        ? 'Rs. ${course.discountedPrice}'
                        : 'Rs. ${course.price}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const Spacer(),
                      // Agar discount hai, to purani price line-through ke saath dikhao
                      if (hasValidDiscount)
                        Text(
                          'Rs. ${course.price}',
                          style: textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red.shade300,
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
