import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wapexp/admin_app/features/announcements/domain/entities/announcement_entity.dart';
import 'package:wapexp/admin_app/features/announcements/presentation/bloc/announcement_bloc.dart';
import 'package:wapexp/admin_app/features/announcements/presentation/bloc/announcement_event.dart';
import 'package:wapexp/admin_app/features/announcements/presentation/bloc/announcement_state.dart';
import 'package:wapexp/admin_app/features/auth/presentation/widgets/custom_button.dart';

class AddEditAnnouncementPage extends StatefulWidget {
  final AnnouncementEntity? announcement;
  const AddEditAnnouncementPage({super.key, this.announcement});

  @override
  State<AddEditAnnouncementPage> createState() =>
      _AddEditAnnouncementPageState();
}

class _AddEditAnnouncementPageState extends State<AddEditAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool get isEditMode => widget.announcement != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.announcement!.title;
      _descriptionController.text = widget.announcement!.description;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        final updated = AnnouncementEntity(
          id: widget.announcement!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          date: widget.announcement!.date, // Date update nahi kar rahe
        );
        context.read<AnnouncementBloc>().add(
          UpdateAnnouncementButtonPressed(announcement: updated),
        );
      } else {
        context.read<AnnouncementBloc>().add(
          AddAnnouncementButtonPressed(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Announcement' : 'Add Announcement'),
      ),
      body: BlocListener<AnnouncementBloc, AnnouncementState>(
        listener: (context, state) {
          if (state is AnnouncementActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AnnouncementFailure) {
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
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              BlocBuilder<AnnouncementBloc, AnnouncementState>(
                builder: (context, state) {
                  return CustomButton(
                    text: isEditMode ? 'Update' : 'Post Announcement',
                    isLoading: state is AnnouncementLoading,
                    onPressed: _save,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
