import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wapexp/features/auth/presentation/widgets/custom_button.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_bloc.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_event.dart';
import 'package:wapexp/features/courses/presentation/bloc/course_state.dart';
import 'package:wapexp/features/courses/presentation/widgets/section_header.dart';

class AddEditCoursePage extends StatefulWidget {
  const AddEditCoursePage({super.key});

  @override
  State<AddEditCoursePage> createState() => _AddEditCoursePageState();
}

class _AddEditCoursePageState extends State<AddEditCoursePage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _durationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _offerEndDateController = TextEditingController();

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
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null)
      setState(() => controller.text = DateFormat('yyyy-MM-dd').format(picked));
  }

  void _saveCourse() {
    // Validate form and image
    if (_formKey.currentState!.validate() && _image != null) {
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
    } else if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a course image.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String hintText, {IconData? icon}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      filled: true,
      fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Course')),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Course added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(); // Go back to the previous screen
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
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text('Tap to select an image'),
                            ],
                          ),
                        ),
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
                  'Course Duration (e.g., 3 Months)',
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
                    text: 'Save Course',
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
