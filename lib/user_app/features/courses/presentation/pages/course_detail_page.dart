import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wapexp/admin_app/features/courses/domain/entities/course_entity.dart';

class CourseDetailPage extends StatelessWidget {
  final CourseEntity course;
  const CourseDetailPage({super.key, required this.course});

  void _launchWhatsApp(BuildContext context) async {
    const phoneNumber = "923217658485";
    final message = "Hi, I'm interested in the '${course.name}' course.";
    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Could not launch WhatsApp. Please make sure it's installed.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool hasDiscount =
        course.discountedPrice != null && course.discountedPrice!.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            stretch: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 12,
              ),
              title: Text(
                course.name,
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [const Shadow(blurRadius: 2, color: Colors.black54)],
                ),
                textAlign: TextAlign.center,
              ),
              background: Hero(
                tag: 'course_image_${course.id}',
                child: Image.network(
                  course.imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.5),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _buildInfoChip(
                          context,
                          Icons.timer_outlined,
                          course.duration,
                        ),
                        const Spacer(),
                        if (!hasDiscount)
                          Text(
                            'Rs. ${course.price}',
                            style: textTheme.headlineSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),

                    if (hasDiscount) ...[
                      const SizedBox(height: 16),
                      _buildDiscountOfferCard(context),
                    ],

                    const SizedBox(height: 32),
                    Text(
                      'About this course',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course.description,
                      style: textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: colors.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildScheduleCard(context),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _launchWhatsApp(context),
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            label: const Text(
              'Contact on WhatsApp for Admission',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String value) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountOfferCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final originalPrice = double.tryParse(course.price) ?? 0.0;
    final discountedPrice = double.tryParse(course.discountedPrice!) ?? 0.0;
    final double savedAmount = originalPrice - discountedPrice;
    final double percentageSaved = (savedAmount / originalPrice) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rs. ${course.price}',
                  style: textTheme.titleMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${course.discountedPrice}',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${percentageSaved.toStringAsFixed(0)}% OFF',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDateRow(
              'Starts On:',
              DateFormat('MMMM d, yyyy').format(course.startDate!),
            ),
            if (course.endDate != null) ...[
              const Divider(height: 24),
              _buildDateRow(
                'Ends On:',
                DateFormat('MMMM d, yyyy').format(course.endDate!),
              ),
            ],
            if (course.offerEndDate != null) ...[
              const Divider(height: 24),
              _buildDateRow(
                'Offer Ends:',
                DateFormat('MMMM d, yyyy').format(course.offerEndDate!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
