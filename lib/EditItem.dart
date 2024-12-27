import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final ValueChanged<Map<String, dynamic>> onSave;

  const EditItem({
    super.key,
    required this.item,
    required this.onSave,
  });

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  String? _type;
  String? _color;
  String? _attire;
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item['name']);
    _brandController = TextEditingController(text: widget.item['brand']);
    _type = widget.item['type'];
    _color = widget.item['color'];
    _attire = widget.item['attire'];
    _imagePath = widget.item['image'];  // Load existing image if available
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;  // Update the selected image path
      });
      print('Selected image path: $_imagePath');
    }
  }

  void _saveChanges() {
    // Basic validation
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    final updatedItem = {
      ...widget.item,
      'name': _nameController.text.trim(),
      'brand': _brandController.text.trim(),
      'type': _type,
      'color': _color,
      'attire': _attire,
      'image': _imagePath,  // Include the updated image path
    };

    widget.onSave(updatedItem);
    Navigator.pop(context, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100], // Light background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image editing
              Center(
                child: GestureDetector(
                  onTap: _pickImage, // Open image picker when tapped
                  child: _imagePath != null
                      ? Image.file(
                          File(_imagePath!),
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.image,
                          size: 150,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Name field
              _buildTextField(
                controller: _nameController,
                labelText: 'Name',
                hintText: 'Enter the item name',
              ),
              const SizedBox(height: 16),

              // Brand field
              _buildTextField(
                controller: _brandController,
                labelText: 'Brand',
                hintText: 'Enter the brand name (optional)',
              ),
              const SizedBox(height: 16),

              // Type dropdown
              _buildDropdownField(
                labelText: 'Type',
                value: _type,
                items: ['Shirt', 'Pants', 'Dress', 'Jacket'],
                onChanged: (value) => setState(() {
                  _type = value;
                }),
              ),
              const SizedBox(height: 16),

              // Color dropdown
              _buildDropdownField(
                labelText: 'Color',
                value: _color,
                items: ['Red', 'Blue', 'Green', 'Black', 'White'],
                onChanged: (value) => setState(() {
                  _color = value;
                }),
              ),
              const SizedBox(height: 16),

              // Attire dropdown
              _buildDropdownField(
                labelText: 'Attire',
                value: _attire,
                items: ['Casual', 'Formal', 'Business Casual', 'Sporty'],
                onChanged: (value) => setState(() {
                  _attire = value;
                }),
              ),
              const SizedBox(height: 32),

              // Save button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // Helper method for dropdown fields
  Widget _buildDropdownField({
    required String labelText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  // Save button with rounded corners and custom style
  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: const Text('Save', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
