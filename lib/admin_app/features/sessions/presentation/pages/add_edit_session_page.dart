import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/admin_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:wapexp/admin_app/features/courses/presentation/widgets/section_header.dart';
import 'package:wapexp/admin_app/features/sessions/domain/entities/session_entity.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/bloc/session_bloc.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/bloc/session_event.dart';
import 'package:wapexp/admin_app/features/sessions/presentation/bloc/session_state.dart';

class AddEditSessionPage extends StatefulWidget {
  final SessionEntity? session;
  const AddEditSessionPage({super.key, this.session});

  @override
  State<AddEditSessionPage> createState() => _AddEditSessionPageState();
}

class _AddEditSessionPageState extends State<AddEditSessionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  File? _coverImage;
  List<File> _galleryImages = [];
  String? _existingCoverUrl;
  List<String> _existingGalleryUrls = [];

  final ImagePicker _picker = ImagePicker();
  bool get isEditMode => widget.session != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final session = widget.session!;
      _nameController.text = session.name;
      _dateController.text = DateFormat('yyyy-MM-dd').format(session.date);
      _existingCoverUrl = session.coverImageUrl;
      _existingGalleryUrls = session.galleryImageUrls;
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

  void _saveSession() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        // TODO: Handle image updates for edit mode
        final updated = SessionEntity(
          id: widget.session!.id,
          name: _nameController.text.trim(),
          date: DateTime.parse(_dateController.text.trim()),
          coverImageUrl: _existingCoverUrl!,
          galleryImageUrls: _existingGalleryUrls,
        );
        context.read<SessionBloc>().add(
          UpdateSessionButtonPressed(session: updated),
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
        context.read<SessionBloc>().add(
          AddSessionButtonPressed(
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
      appBar: AppBar(title: Text(isEditMode ? 'Edit Session' : 'Add Session')),
      body: BlocListener<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state is SessionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is SessionFailure) {
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
              const SectionHeader(title: 'Session Details'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Session Name'),
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
              BlocBuilder<SessionBloc, SessionState>(
                builder: (context, state) {
                  return CustomButton(
                    text: isEditMode ? 'Update Session' : 'Save Session',
                    isLoading: state is SessionLoading,
                    onPressed: _saveSession,
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
