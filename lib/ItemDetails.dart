import 'package:flutter/material.dart';
import 'EditItem.dart'; // Ensure this file exists and contains the EditItem widget.

class ItemDetails extends StatelessWidget {
  final Map<String, dynamic> item;
  final ValueChanged<Map<String, dynamic>> onEdit; // Callback when item is updated
  final VoidCallback onDelete; // Callback for delete action
  final ValueChanged<Map<String, dynamic>> onUsedToggle; // Callback to toggle the used/unused status

  const ItemDetails({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onUsedToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUsed = item['tag'] == 'used'; // Check if the item is marked as used

    return Scaffold(
      appBar: AppBar(
        title: Text(item['name'] ?? 'Item Details'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  // Optionally, add logic here for interacting with the image
                  print('Image tapped');
                },
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
            ),
            const SizedBox(height: 20),
            _buildDetailCard('Name', item['name']),
            _buildDetailCard('Brand', item['brand']),
            _buildDetailCard('Type', item['type']),
            _buildDetailCard('Color', item['color']),
            _buildDetailCard('Attire', item['attire']),
            _buildDetailCard('Last Used', _formatLastUsed(item['lastUsed'])),
            _buildDetailCard('Status', isUsed ? 'Used' : 'Unused'),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 84, 199, 234),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () async {
                  // Navigate to EditItem and await the updated item data
                  final updatedItem = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditItem(
                        item: item,  // Pass the current item to EditItem
                        onSave: onEdit,  // Pass the onSave callback to EditItem
                      ),
                    ),
                  );

                  // If an updated item is returned, invoke onEdit callback
                  if (updatedItem != null) {
                    onEdit(updatedItem);
                  }
                },
                child: const Text('Edit', style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            // Removed the "Mark as Used" button as per your request
          ],
        ),
      ),
    );
  }

  // Helper method to build a detailed card for each item property
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

  // Helper method to format the lastUsed date
  String _formatLastUsed(String? lastUsed) {
    if (lastUsed == null || lastUsed.isEmpty) {
      return 'Never used';
    }
    return lastUsed;
  }

  // Method to confirm deletion of an item
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // This method ensures that lastUsed only updates when the item is marked as 'used'
  void onUsedToggleCallback(Map<String, dynamic> updatedItem) {
    if (updatedItem['tag'] == 'used') {
      // Only update lastUsed if it is not already set
      if (updatedItem['lastUsed'] == null || updatedItem['lastUsed'].isEmpty) {
        updatedItem['lastUsed'] = DateTime.now().toString(); // Set lastUsed only when marking as used
      }
    }
    // Pass the updated item to the parent callback to update the state
    onUsedToggle(updatedItem);
  }
}
