import 'package:flutter/material.dart';
import 'CloseOptions.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _newOptionController = TextEditingController();

  String? _imagePath;
  String _clothingType = ClosetOptions.clothingTypes.first;
  String _color = ClosetOptions.colors.first;
  String _attire = ClosetOptions.attires.first;

  void _addNewOption(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New $category'),
        content: TextField(
          controller: _newOptionController,
          decoration: InputDecoration(hintText: 'Enter new $category'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (category == 'Type') {
                  ClosetOptions.addOption(ClosetOptions.clothingTypes, _newOptionController.text);
                  _clothingType = _newOptionController.text;
                } else if (category == 'Color') {
                  ClosetOptions.addOption(ClosetOptions.colors, _newOptionController.text);
                  _color = _newOptionController.text;
                } else if (category == 'Attire') {
                  ClosetOptions.addOption(ClosetOptions.attires, _newOptionController.text);
                  _attire = _newOptionController.text;
                }
              });
              _newOptionController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Upload Photo
              GestureDetector(
                onTap: () {
                  setState(() {
                    _imagePath = 'assets/new_image.png';
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 150,
                  child: _imagePath == null
                      ? const Center(
                          child: Text(
                            'Tap to Add Photo',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            _imagePath!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Name and Brand
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Dropdowns with Add Options
              _buildDropdownSection(
                'Clothing Type',
                _clothingType,
                ClosetOptions.clothingTypes,
                (newValue) {
                  setState(() {
                    _clothingType = newValue!;
                  });
                },
                () => _addNewOption('Type'),
              ),
              const SizedBox(height: 20),
              _buildDropdownSection(
                'Color',
                _color,
                ClosetOptions.colors,
                (newValue) {
                  setState(() {
                    _color = newValue!;
                  });
                },
                () => _addNewOption('Color'),
              ),
              const SizedBox(height: 20),
              _buildDropdownSection(
                'Attire',
                _attire,
                ClosetOptions.attires,
                (newValue) {
                  setState(() {
                    _attire = newValue!;
                  });
                },
                () => _addNewOption('Attire'),
              ),
              const SizedBox(height: 40),
              // Add Item Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_nameController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Missing Name'),
                        content: const Text('Please enter a name for the item.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final newItem = {
                      'name': _nameController.text,
                      'brand': _brandController.text,
                      'image': _imagePath ?? '',
                      'type': _clothingType,
                      'color': _color,
                      'attire': _attire,
                    };
                    Navigator.pop(context, newItem);
                  }
                },
                child: const Text(
                  'Add Item',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection(
    String label,
    String selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
    VoidCallback onAdd,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: onChanged,
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: onAdd,
            ),
          ],
        ),
      ],
    );
  }
}
