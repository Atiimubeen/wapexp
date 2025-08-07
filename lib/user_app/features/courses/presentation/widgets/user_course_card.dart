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

    // Check if discount is valid - simplified check
    final bool hasValidDiscount =
        course.discountedPrice != null &&
        course.discountedPrice!.isNotEmpty &&
        course.discountedPrice != "0" &&
        course.discountedPrice != course.price;

    // Calculate discount percentage
    double discountPercentage = 0;
    if (hasValidDiscount) {
      final originalPrice = double.tryParse(course.price) ?? 0.0;
      final discountedPrice = double.tryParse(course.discountedPrice!) ?? 0.0;
      if (originalPrice > 0) {
        discountPercentage =
            ((originalPrice - discountedPrice) / originalPrice) * 100;
      }
    }

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
                // Price tag on image
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: hasValidDiscount
                        ? Colors.green.shade700
                        : colors.primary,
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
                // Discount percentage badge
                if (hasValidDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${discountPercentage.toStringAsFixed(0)}% OFF',
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
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Price section - more prominent for discounts
                  if (hasValidDiscount) ...[
                    Row(
                      children: [
                        Text(
                          'Rs. ${course.price}',
                          style: textTheme.titleSmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Rs. ${course.discountedPrice}',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Duration row
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
                      // Show regular price if no discount
                      if (!hasValidDiscount)
                        Text(
                          'Rs. ${course.price}',
                          style: textTheme.titleSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
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
