import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wapexp/admin_app/features/slider_images/domain/entities/slider_image_entity.dart';
import 'package:wapexp/admin_app/features/slider_images/presentation/bloc/slider_image_bloc.dart';
import 'package:wapexp/admin_app/features/slider_images/presentation/bloc/slider_image_event.dart';
import 'package:wapexp/admin_app/features/slider_images/presentation/bloc/slider_image_state.dart';
import 'package:wapexp/admin_app/admin_injection_container.dart';

// **FIX 1: Converted to StatefulWidget**
class ManageSliderImagesPage extends StatefulWidget {
  const ManageSliderImagesPage({super.key});

  @override
  State<ManageSliderImagesPage> createState() => _ManageSliderImagesPageState();
}

class _ManageSliderImagesPageState extends State<ManageSliderImagesPage> {
  // **FIX 2: Create a single instance of ImagePicker**
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadImage(BuildContext context) async {
    // **FIX 3: Use the single instance**
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null && mounted) {
      context.read<SliderImageBloc>().add(
        AddSliderImage(image: File(pickedFile.path)),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, SliderImageEntity image) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              context.read<SliderImageBloc>().add(
                DeleteSliderImage(image: image),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SliderImageBloc>()..add(LoadSliderImages()),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: AppBar(title: const Text('Manage Slider Images')),
            body: BlocConsumer<SliderImageBloc, SliderImageState>(
              buildWhen: (p, c) => c is! SliderImageActionSuccess,
              listener: (context, state) {
                if (state is SliderImageActionSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                  context.read<SliderImageBloc>().add(LoadSliderImages());
                } else if (state is SliderImageFailure) {
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
                if (state is SliderImageLoading ||
                    state is SliderImageInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SliderImageFailure) {
                  return Center(child: Text(state.message));
                }
                if (state is SliderImagesLoaded) {
                  if (state.images.isEmpty) {
                    return const Center(
                      child: Text('No slider images found. Add one!'),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: state.images.length,
                    itemBuilder: (context, index) {
                      final image = state.images[index];
                      return GridTile(
                        footer: GridTileBar(
                          backgroundColor: Colors.black45,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () =>
                                _showDeleteConfirmation(innerContext, image),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            image.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _pickAndUploadImage(innerContext),
              tooltip: 'Add New Image',
              child: const Icon(Icons.add_photo_alternate_outlined),
            ),
          );
        },
      ),
    );
  }
}
