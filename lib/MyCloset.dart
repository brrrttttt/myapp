import 'package:flutter/material.dart';
import 'AddItem.dart';

class MyCloset extends StatefulWidget {
  const MyCloset({super.key});

  @override
  MyClosetState createState() => MyClosetState();
}

class MyClosetState extends State<MyCloset> {
  final List<Map<String, dynamic>> _closetItems = [];
  String _filter = 'all'; // Filter selection: "all", "used", "unused", "favorite"
  String _searchQuery = ''; // Search query
  String _typeFilter = 'All'; // Clothing type filter
  String _colorFilter = 'All'; // Color filter
  String _attireFilter = 'All'; // Attire filter

  // Toggle favorite status
  void _toggleFavorite(String itemName) {
    setState(() {
      final item = _closetItems.firstWhere((i) => i['name'] == itemName);
      item['favorite'] = !(item['favorite'] ?? false);
    });
  }

  // Toggle used/unused status
  void _toggleUsedStatus(String itemName) {
    setState(() {
      final item = _closetItems.firstWhere((i) => i['name'] == itemName);
      item['tag'] = item['tag'] == 'used' ? 'unused' : 'used';
    });
  }

  // Show confirmation dialog before deleting an item
  Future<void> _confirmDelete(Map<String, dynamic> item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _closetItems.remove(item);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['name']} has been deleted.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Get filtered and searched items
  List<Map<String, dynamic>> _getFilteredItems() {
    return _closetItems
        .where((item) =>
            (_filter == 'all' ||
                item['tag'] == _filter ||
                (_filter == 'favorite' && item['favorite'] == true)) &&
            (item['type'] == _typeFilter || _typeFilter == 'All') &&
            (item['color'] == _colorFilter || _colorFilter == 'All') &&
            (item['attire'] == _attireFilter || _attireFilter == 'All') &&
            item['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
      ..sort((a, b) =>
          a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Closet'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search items...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // Filter Buttons (Used, Unused, Favorites)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton('All', 'all'),
                const SizedBox(width: 10),
                _buildFilterButton('Used', 'used'),
                const SizedBox(width: 10),
                _buildFilterButton('Unused', 'unused'),
                const SizedBox(width: 10),
                _buildFilterButton('Favorites', 'favorite'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Additional Scrollable Filters (Type, Color, Attire)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDropdownFilter(
                  'Type',
                  ['All', 'Shirt', 'Pants', 'Dress', 'Jacket'],
                  _typeFilter,
                  (value) {
                    setState(() {
                      _typeFilter = value!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                _buildDropdownFilter(
                  'Color',
                  ['All', 'Red', 'Blue', 'Green', 'Black', 'White'],
                  _colorFilter,
                  (value) {
                    setState(() {
                      _colorFilter = value!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                _buildDropdownFilter(
                  'Attire',
                  ['All', 'Casual', 'Formal', 'Business Casual', 'Sporty'],
                  _attireFilter,
                  (value) {
                    setState(() {
                      _attireFilter = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Closet Items List
          Expanded(
            child: _closetItems.isEmpty
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checkroom, size: 80, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'No items in the closet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: _getFilteredItems().length,
                    itemBuilder: (context, index) {
                      final item = _getFilteredItems()[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: item['image'] != null && item['image'] != ''
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(item['image']),
                                  radius: 25, // Avatar size
                                )
                              : const CircleAvatar(
                                  radius: 25,
                                  child: Icon(Icons.image, size: 30),
                                ),
                          title: Text(
                            item['name']!,
                            overflow: TextOverflow.ellipsis, // Truncate long names
                          ),
                          subtitle: Text('${item['type']} - ${item['color']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  item['favorite'] == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: item['favorite'] == true
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () => _toggleFavorite(item['name']!),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmDelete(item),
                              ),
                            ],
                          ),
                          onTap: () => _toggleUsedStatus(item['name']!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push<Map<String, String>>(
            context,
            MaterialPageRoute(builder: (context) => const AddItem()),
          );

          if (newItem != null) {
            setState(() {
              _closetItems.add({
                'name': newItem['name']!,
                'brand': newItem['brand'] ?? '',
                'image': newItem['image'] ?? '',
                'type': newItem['type'] ?? '',
                'color': newItem['color'] ?? '',
                'attire': newItem['attire'] ?? '',
                'tag': 'unused',
                'favorite': false,
              });
            });
          }
        },
        tooltip: 'Add Item',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Helper to build filter buttons
  Widget _buildFilterButton(String label, String filterValue) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _filter = filterValue;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _filter == filterValue ? Colors.grey : Colors.white,
      ),
      child: Text(label),
    );
  }

  // Helper to build dropdown filters
  Widget _buildDropdownFilter(
      String label, List<String> options, String currentValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: currentValue,
      onChanged: onChanged,
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
