import 'package:flutter/material.dart';
import 'EditItem.dart'; // Ensure this file exists and contains the EditItem widget.

class ItemDetails extends StatelessWidget {
  final Map<String, dynamic> item;
  final ValueChanged<Map<String, dynamic>> onEdit; // Callback when item is updated
  final VoidCallback onDelete; // Callback for delete action

  const ItemDetails({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name'] ?? 'Item Details'),
        backgroundColor: Colors.deepPurple,
        actions: [
          // Delete Icon
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () {
              _confirmDelete(context); // Trigger the delete confirmation dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(  // Wrap content in SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image or placeholder icon
            Center(
              child: item['image'] != null && item['image'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        item['image'],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.image,
                      size: 150,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 20),

            // Display item details in a card style
            _buildDetailCard('Name', item['name']),
            _buildDetailCard('Brand', item['brand']),
            _buildDetailCard('Type', item['type']),
            _buildDetailCard('Color', item['color']),
            _buildDetailCard('Attire', item['attire']),

            const SizedBox(height: 20),

            // Edit Button with rounded corners and a gradient background
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 84, 199, 234),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () async {
                  // Navigate to the EditItem screen and wait for the result
                  final updatedItem =
                      await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditItem(
                        item: item,
                        onSave: (updatedItem) {
                          onEdit(updatedItem); // Update the parent item list
                        },
                      ),
                    ),
                  );

                  // If an updated item is returned, notify the parent widget
                  if (updatedItem != null) {
                    onEdit(updatedItem); // Update the item in the parent widget
                  }
                },
                child: const Text('Edit', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to display item details in a card style
  Widget _buildDetailCard(String label, String? value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: Text(
                value ?? 'N/A',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to confirm delete action
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          // Delete button
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog first
              onDelete(); // Perform the delete action
              // Ensure that the delete is performed before navigating back
              Navigator.pop(context); // Pop the ItemDetails screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
