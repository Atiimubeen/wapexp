import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/admin_app/features/achievements/domain/entities/achievement_entity.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/bloc/achievement_bloc.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/bloc/achievement_event.dart';
import 'package:wapexp/admin_app/features/achievements/presentation/bloc/achievement_state.dart';
import 'package:wapexp/admin_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:wapexp/admin_app/features/courses/presentation/widgets/section_header.dart';
import 'package:wapexp/core/utils/image_helper.dart';

class AddEditAchievementPage extends StatefulWidget {
  final AchievementEntity? achievement;
  const AddEditAchievementPage({super.key, this.achievement});

  @override
  State<AddEditAchievementPage> createState() => _AddEditAchievementPageState();
}

class _AddEditAchievementPageState extends State<AddEditAchievementPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  File? _coverImage;
  List<File> _galleryImages = [];
  String? _existingCoverUrl;
  List<String> _existingGalleryUrls = [];

  bool _isProcessingCover = false;
  bool _isProcessingGallery = false;

  final ImagePicker _picker = ImagePicker();
  bool get isEditMode => widget.achievement != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final ach = widget.achievement!;
      _nameController.text = ach.name;
      _dateController.text = DateFormat('yyyy-MM-dd').format(ach.date);
      _existingCoverUrl = ach.coverImageUrl;
      _existingGalleryUrls = List.from(ach.galleryImageUrls);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile == null || !mounted) return;

      setState(() => _isProcessingCover = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Processing cover image...'),
            ],
          ),
          duration: Duration(minutes: 1),
        ),
      );

      // Process the image with rotation fix and compression
      final processedImage = await ImageHelper.processImage(
        File(pickedFile.path),
        fixRotation: true,
        compress: true,
        quality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      final isValid = await ImageHelper.isValidImageFile(processedImage);

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (isValid) {
        setState(() {
          _coverImage = processedImage;
          _existingCoverUrl = null; // Clear existing when new one is selected
          _isProcessingCover = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cover image processed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() => _isProcessingCover = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process cover image. Please try another.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessingCover = false);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting cover image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickGalleryImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage(imageQuality: 100);

      if (pickedFiles.isEmpty || !mounted) return;

      setState(() => _isProcessingGallery = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 16),
              Text('Processing ${pickedFiles.length} gallery images...'),
            ],
          ),
          duration: const Duration(minutes: 2),
        ),
      );

      List<File> processedImages = [];
      int successCount = 0;

      for (final pickedFile in pickedFiles) {
        try {
          final processedImage = await ImageHelper.processImage(
            File(pickedFile.path),
            fixRotation: true,
            compress: true,
            quality: 85,
            maxWidth: 1920,
            maxHeight: 1920,
          );

          final isValid = await ImageHelper.isValidImageFile(processedImage);
          if (isValid) {
            processedImages.add(processedImage);
            successCount++;
          }
        } catch (e) {
          print('Error processing gallery image: $e');
          // Continue with other images
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (processedImages.isNotEmpty) {
        setState(() {
          _galleryImages.addAll(processedImages);
          _isProcessingGallery = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$successCount gallery images processed successfully!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        setState(() => _isProcessingGallery = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process any gallery images.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessingGallery = false);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting gallery images: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeGalleryImage(int index) {
    setState(() {
      _galleryImages.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isEditMode ? widget.achievement!.date : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _saveAchievement() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        final updated = AchievementEntity(
          id: widget.achievement!.id,
          name: _nameController.text.trim(),
          date: DateTime.parse(_dateController.text.trim()),
          coverImageUrl: widget.achievement!.coverImageUrl,
          galleryImageUrls: widget.achievement!.galleryImageUrls,
        );
        context.read<AchievementBloc>().add(
          UpdateAchievementButtonPressed(
            achievement: updated,
            newCoverImage: _coverImage,
            newGalleryImages: _galleryImages.isNotEmpty ? _galleryImages : null,
          ),
        );
      } else {
        // Validation for new achievement
        if (_coverImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a cover image.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        if (_galleryImages.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select at least one gallery image.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        context.read<AchievementBloc>().add(
          AddAchievementButtonPressed(
            name: _nameController.text.trim(),
            date: DateTime.parse(_dateController.text.trim()),
            coverImage: _coverImage!,
            galleryImages: _galleryImages,
          ),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String labelText) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.7)),
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 12.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.onSurface.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.onSurface.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Achievement' : 'Add Achievement'),
      ),
      body: BlocListener<AchievementBloc, AchievementState>(
        listener: (context, state) {
          if (state is AchievementActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AchievementFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SectionHeader(title: 'Achievement Details'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Achievement Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: _inputDecoration('Date'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SectionHeader(title: 'Cover Image'),
              _buildCoverImagePicker(),
              const SectionHeader(title: 'Gallery Images'),
              _buildGalleryImagePicker(),
              const SizedBox(height: 32),
              BlocBuilder<AchievementBloc, AchievementState>(
                builder: (context, state) {
                  final isLoading =
                      state is AchievementLoading ||
                      _isProcessingCover ||
                      _isProcessingGallery;

                  return CustomButton(
                    text: isEditMode
                        ? 'Update Achievement'
                        : 'Save Achievement',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _saveAchievement,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImagePicker() {
    return GestureDetector(
      onTap: _isProcessingCover ? null : _pickCoverImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isProcessingCover
                ? Colors.blue.shade300
                : Colors.grey.shade400,
            width: 1,
          ),
        ),
        child: _isProcessingCover
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing cover image...'),
                  ],
                ),
              )
            : _coverImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  _coverImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 50),
                        Text('Error loading image'),
                      ],
                    ),
                  ),
                ),
              )
            : (_existingCoverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        _existingCoverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('Tap to select cover image'),
                        ],
                      ),
                    )),
      ),
    );
  }

  Widget _buildGalleryImagePicker() {
    final totalImages = _existingGalleryUrls.length + _galleryImages.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _isProcessingGallery ? null : _pickGalleryImages,
          icon: _isProcessingGallery
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_photo_alternate_outlined),
          label: Text(
            _isProcessingGallery
                ? 'Processing images...'
                : 'Add Gallery Images ($totalImages total)',
          ),
        ),
        const SizedBox(height: 16),
        if (totalImages == 0)
          const Text(
            'No gallery images selected.',
            style: TextStyle(color: Colors.grey),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: totalImages,
              itemBuilder: (context, index) {
                // Show existing images first
                if (index < _existingGalleryUrls.length) {
                  final imageUrl = _existingGalleryUrls[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Show newly selected images with remove button
                  final imageIndex = index - _existingGalleryUrls.length;
                  final imageFile = _galleryImages[imageIndex];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            imageFile,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeGalleryImage(imageIndex),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}
