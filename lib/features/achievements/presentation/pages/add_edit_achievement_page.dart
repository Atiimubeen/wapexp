import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/features/achievements/domain/entities/achievement_entity.dart';
import 'package:wapexp/features/achievements/presentation/bloc/achievement_bloc.dart';
import 'package:wapexp/features/achievements/presentation/bloc/achievement_event.dart';
import 'package:wapexp/features/achievements/presentation/bloc/achievement_state.dart';
import 'package:wapexp/features/auth/presentation/widgets/custom_button.dart';
import 'package:wapexp/features/courses/presentation/widgets/section_header.dart';

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
      _existingGalleryUrls = ach.galleryImageUrls;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) setState(() => _coverImage = File(pickedFile.path));
  }

  Future<void> _pickGalleryImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 80);
    if (pickedFiles.isNotEmpty)
      setState(
        () => _galleryImages = pickedFiles
            .map((file) => File(file.path))
            .toList(),
      );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null)
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
  }

  void _saveAchievement() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        final updated = AchievementEntity(
          id: widget.achievement!.id,
          name: _nameController.text.trim(),
          date: DateTime.parse(_dateController.text.trim()),
          coverImageUrl: _existingCoverUrl!,
          galleryImageUrls: _existingGalleryUrls,
        );
        context.read<AchievementBloc>().add(
          UpdateAchievementButtonPressed(achievement: updated),
        );
      } else {
        if (_coverImage == null || _galleryImages.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please select a cover image and at least one gallery image.',
              ),
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
    return InputDecoration(labelText: labelText);
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
                  return CustomButton(
                    text: isEditMode
                        ? 'Update Achievement'
                        : 'Save Achievement',
                    isLoading: state is AchievementLoading,
                    onPressed: _saveAchievement,
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
      onTap: _pickCoverImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: _coverImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(_coverImage!, fit: BoxFit.cover),
              )
            : (_existingCoverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        _existingCoverUrl!,
                        fit: BoxFit.cover,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _pickGalleryImages,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: Text('Select Gallery Images (${_galleryImages.length})'),
        ),
        const SizedBox(height: 16),
        if (_galleryImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _galleryImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _galleryImages[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )
        else if (isEditMode && _existingGalleryUrls.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _existingGalleryUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _existingGalleryUrls[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
