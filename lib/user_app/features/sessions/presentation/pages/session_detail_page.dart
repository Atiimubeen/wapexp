import 'package:flutter/material.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';
import 'package:wapexp/user_app/presentation/widgets/full_screen_image_viewer.dart';

class SessionDetailPage extends StatelessWidget {
  final SessionEntity session;
  const SessionDetailPage({super.key, required this.session});

  void _openImageViewer(
    BuildContext context, {
    required List<String> imageUrls,
    required int initialIndex,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullScreenImageViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [session.coverImageUrl, ...session.galleryImageUrls];

    return Scaffold(
      appBar: AppBar(title: Text(session.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **CLICKABLE COVER IMAGE**
            GestureDetector(
              onTap: () => _openImageViewer(
                context,
                imageUrls: allImages,
                initialIndex: 0,
              ),
              child: Hero(
                tag: session.coverImageUrl + "0",
                child: Image.network(
                  session.coverImageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Gallery',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            // **CLICKABLE GALLERY IMAGES**
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: session.galleryImageUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = session.galleryImageUrls[index];
                return GestureDetector(
                  onTap: () => _openImageViewer(
                    context,
                    imageUrls: allImages,
                    initialIndex: index + 1,
                  ),
                  child: Hero(
                    tag: imageUrl + (index + 1).toString(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
