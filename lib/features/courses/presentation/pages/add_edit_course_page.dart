import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/features/auth/presentation/widgets/custom_button.dart';
import 'package:wapexp/features/courses/domain/entities/course_entity.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_bloc.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_event.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_state.dart';
import 'package:wapexp/features/courses/presentation/widgets/section_header.dart';

class AddEditCoursePage extends StatefulWidget {
  final CourseEntity? course; // Yeh parameter "Edit" ke liye data laata hai
  const AddEditCoursePage({super.key, this.course});

  @override
  State<AddEditCoursePage> createState() => _AddEditCoursePageState();
}

class _AddEditCoursePageState extends State<AddEditCoursePage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String? _existingImageUrl;

  // **THE FIX IS HERE:** Hum ImagePicker ki ek hi instance banayenge.
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _durationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _offerEndDateController = TextEditingController();

  bool get isEditMode => widget.course != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final course = widget.course!;
      _nameController.text = course.name;
      _descriptionController.text = course.description;
      _priceController.text = course.price;
      _discountedPriceController.text = course.discountedPrice ?? '';
      _durationController.text = course.duration;
      _startDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(course.startDate!);
      _endDateController.text = course.endDate != null
          ? DateFormat('yyyy-MM-dd').format(course.endDate!)
          : '';
      _offerEndDateController.text = course.offerEndDate != null
          ? DateFormat('yyyy-MM-dd').format(course.offerEndDate!)
          : '';
      _existingImageUrl = course.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountedPriceController.dispose();
    _durationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _offerEndDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // **THE FIX IS HERE:** Hum pehle se banayi hui instance ko istemal karenge.
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _existingImageUrl = null;
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        final updatedCourse = CourseEntity(
          id: widget.course!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: _priceController.text.trim(),
          discountedPrice: _discountedPriceController.text.trim(),
          duration: _durationController.text.trim(),
          imageUrl: _existingImageUrl ?? widget.course!.imageUrl,
          startDate: DateTime.parse(_startDateController.text.trim()),
          endDate: _endDateController.text.trim().isNotEmpty
              ? DateTime.parse(_endDateController.text.trim())
              : null,
          offerEndDate: _offerEndDateController.text.trim().isNotEmpty
              ? DateTime.parse(_offerEndDateController.text.trim())
              : null,
        );
        context.read<CourseBloc>().add(
          UpdateCourseButtonPressed(course: updatedCourse),
        );
      } else {
        if (_image == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a course image.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        context.read<CourseBloc>().add(
          AddCourseButtonPressed(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: _priceController.text.trim(),
            discountedPrice: _discountedPriceController.text.trim(),
            duration: _durationController.text.trim(),
            image: _image!,
            startDate: _startDateController.text.trim(),
            endDate: _endDateController.text.trim(),
            offerEndDate: _offerEndDateController.text.trim(),
          ),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String hintText, {IconData? icon}) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: colors.onSurface.withOpacity(0.5)),
      prefixIcon: icon != null
          ? Icon(icon, color: colors.onSurface.withOpacity(0.5), size: 20)
          : null,
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
        title: Text(isEditMode ? 'Edit Course' : 'Add New Course'),
      ),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is CourseFailure) {
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
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            children: [
              const SectionHeader(title: 'Course Image'),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : (_existingImageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Image.network(
                                  _existingImageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      size: 50,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('Tap to select an image'),
                                  ],
                                ),
                              )),
                ),
              ),
              const SectionHeader(title: 'Course Details'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Course Name', icon: Icons.school),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: _inputDecoration(
                  'Duration (e.g., 3 Months)',
                  icon: Icons.timer,
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: _inputDecoration('Course Description'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SectionHeader(title: 'Pricing'),
              TextFormField(
                controller: _priceController,
                decoration: _inputDecoration(
                  'Original Price (e.g., 5000)',
                  icon: Icons.price_change_outlined,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountedPriceController,
                decoration: _inputDecoration(
                  'Discounted Price (Optional)',
                  icon: Icons.price_check_outlined,
                ),
                keyboardType: TextInputType.number,
              ),
              const SectionHeader(title: 'Important Dates'),
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _startDateController),
                decoration: _inputDecoration(
                  'Start Date',
                  icon: Icons.calendar_today_outlined,
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _endDateController),
                decoration: _inputDecoration(
                  'End Date (Optional)',
                  icon: Icons.calendar_month_outlined,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _offerEndDateController,
                readOnly: true,
                onTap: () => _selectDate(context, _offerEndDateController),
                decoration: _inputDecoration(
                  'Discount Offer End Date (Optional)',
                  icon: Icons.event_busy_outlined,
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<CourseBloc, CourseState>(
                builder: (context, state) {
                  return CustomButton(
                    text: isEditMode ? 'Update Course' : 'Save Course',
                    isLoading: state is CourseLoading,
                    onPressed: _saveCourse,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
