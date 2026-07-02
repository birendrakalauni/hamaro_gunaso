import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/complaint_provider.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  String category = "Road";

  final List<String> categories = [
    "Road",
    "Water",
    "Electricity",
    "Sanitation",
    "Health",
    "Education",
    "Infrastructure",
    "Environment",
    "Public Safety",
    "Other",
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> submitComplaint() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<ComplaintProvider>(context, listen: false);

    final success = await provider.addComplaint(
      title: titleController.text.trim(),
      category: category,
      description: descriptionController.text.trim(),
      location: locationController.text.trim(),
      image: _selectedImage,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint submitted successfully")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit complaint")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ComplaintProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Submit Complaint"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.report_problem, size: 80),

              const SizedBox(height: 20),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Complaint Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter complaint title";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: categories.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Complaint Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter description";
                  }

                  if (value.length < 10) {
                    return "Description must be at least 10 characters.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter location";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              if (_selectedImage != null)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Remove Image"),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: Text(
                    _selectedImage == null
                        ? "Choose Image (Optional)"
                        : "Change Image",
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: provider.isLoading ? null : submitComplaint,
                  icon: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    provider.isLoading ? "Submitting..." : "Submit Complaint",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
