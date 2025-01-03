import 'package:flutter/material.dart';
import 'AddItem.dart';
import 'ItemDetails.dart';
import 'ClosetOptions.dart'; // Import the ClosetOptions class

class MyCloset extends StatefulWidget {
  const MyCloset({super.key});

  @override
  MyClosetState createState() => MyClosetState();
}

class MyClosetState extends State<MyCloset> {
  final List<Map<String, dynamic>> _closetItems = [];
  String _filter = 'all';
  String _searchQuery = '';
  String _typeFilter = ClosetOptions.getDefaultOption('Clothing Type');
  String _colorFilter = ClosetOptions.getDefaultOption('Color');
  String _attireFilter = ClosetOptions.getDefaultOption('Attire');
  String _sizeFilter = ClosetOptions.getDefaultOption('Size');

  // Toggle favorite status
  void _toggleFavorite(String itemName) {
    setState(() {
      final item = _closetItems.firstWhere((i) => i['name'] == itemName);
      item['favorite'] = !(item['favorite'] ?? false);
    });
  }

  // Toggle used/unused status and update lastUsed
  void _toggleUsed(Map<String, dynamic> item) {
    setState(() {
      if (item['tag'] == 'unused') {
        item['tag'] = 'used';  // Mark as used
        item['lastUsed'] = DateTime.now().toString();  // Set the current date and time
      } else {
        item['tag'] = 'unused';  // Mark as unused
        item['lastUsed'] = '';  // Reset the lastUsed date when marked as unused
      }
    });
  }

  // Delete an item
  void _deleteItem(Map<String, dynamic> item) {
    setState(() {
      _closetItems.remove(item);
    });
  }

  // Get filtered and searched items
  List<Map<String, dynamic>> _getFilteredItems() {
    return _closetItems
        .where((item) =>
            (_filter == 'all' ||
                item['tag'] == _filter ||
                (_filter == 'favorite' && item['favorite'] == true)) &&
            (item['type'] == _typeFilter || _typeFilter == 'Clothing Type') &&
            (item['color'] == _colorFilter || _colorFilter == 'Color') &&
            (item['attire'] == _attireFilter || _attireFilter == 'Attire') &&
            (item['size'] == _sizeFilter || _sizeFilter == 'Size') &&
            item['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
      ..sort((a, b) =>
          a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()));
  }

  // Reset filter to default
  void _resetFilter(String filterType) {
    setState(() {
      if (filterType == 'Clothing Type') {
        _typeFilter = ClosetOptions.getDefaultOption('Clothing Type');
      } else if (filterType == 'Color') {
        _colorFilter = ClosetOptions.getDefaultOption('Color');
      } else if (filterType == 'Attire') {
        _attireFilter = ClosetOptions.getDefaultOption('Attire');
      } else if (filterType == 'Size') {
        _sizeFilter = ClosetOptions.getDefaultOption('Size');
      }
    });
  }

  // Options for the filters
  List<String> _getFilterOptions(String filterType) {
    return ClosetOptions.getOptionsForFilter(filterType);
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildScrollableFilterButton(
                  'Clothing Type',
                  _typeFilter,
                  () => _resetFilter('Clothing Type'),
                ),
                const SizedBox(width: 10),
                _buildScrollableFilterButton(
                  'Color',
                  _colorFilter,
                  () => _resetFilter('Color'),
                ),
                const SizedBox(width: 10),
                _buildScrollableFilterButton(
                  'Attire',
                  _attireFilter,
                  () => _resetFilter('Attire'),
                ),
                const SizedBox(width: 10),
                _buildScrollableFilterButton(
                  'Size',
                  _sizeFilter,
                  () => _resetFilter('Size'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                          leading: item['image'] != null && item['image'].isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(item['image']),
                                  radius: 25,
                                )
                              : const CircleAvatar(
                                  radius: 25,
                                  child: Icon(Icons.image, size: 30),
                                ),
                          title: Text(
                            item['name']!,
                            overflow: TextOverflow.ellipsis,
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
                                icon: Icon(
                                  item['tag'] == 'used'
                                      ? Icons.checkroom
                                      : Icons.clear_all,
                                ),
                                onPressed: () => _toggleUsed(item),
                              ),
                            ],
                          ),
                          onTap: () async {
                            final updatedItem =
                                await Navigator.push<Map<String, dynamic>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetails(
                                  item: item,
                                  onEdit: (updatedItem) {
                                    setState(() {
                                      final index = _closetItems.indexWhere(
                                          (i) => i['name'] == item['name']);
                                      if (index != -1) {
                                        _closetItems[index] = updatedItem;
                                      }
                                    });
                                  },
                                  onDelete: () {
                                    _deleteItem(item);
                                  },
                                  onUsedToggle: (updatedItem) {
                                    setState(() {
                                      final index = _closetItems.indexWhere(
                                          (i) => i['name'] == item['name']);
                                      if (index != -1) {
                                        _closetItems[index] = updatedItem;
                                      }
                                    });
                                  },
                                ),
                              ),
                            );

                            if (updatedItem != null) {
                              setState(() {
                                final index = _closetItems.indexWhere(
                                    (i) => i['name'] == item['name']);
                                if (index != -1) {
                                  _closetItems[index] = updatedItem;
                                }
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(builder: (context) => const AddItem()),
          );

          if (newItem != null) {
            setState(() {
              _closetItems.add({
                'name': newItem['name']!,
                'brand': newItem['brand'] ?? '',
                'image': newItem['image'] ?? 'assets/images/default_image.png', // Default image
                'type': newItem['type'] ?? '',
                'color': newItem['color'] ?? '',
                'attire': newItem['attire'] ?? '',
                'size': newItem['size'] ?? 'Size',
                'tag': 'unused',
                'favorite': false,
                'lastUsed': '', // Ensure a default value for lastUsed
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

  Widget _buildScrollableFilterButton(
    String label,
    String currentValue,
    VoidCallback onReset,
  ) {
    bool showClearButton = currentValue != label;

    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            final result = await showDialog<String>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Select $label'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: _getFilterOptions(label)
                          .map((option) {
                        return RadioListTile<String>( 
                          title: Text(option),
                          value: option,
                          groupValue: currentValue,
                          onChanged: (value) {
                            Navigator.of(context).pop(value);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );

            if (result != null && result != currentValue) {
              setState(() {
                if (label == 'Clothing Type') {
                  _typeFilter = result;
                } else if (label == 'Color') {
                  _colorFilter = result;
                } else if (label == 'Attire') {
                  _attireFilter = result;
                } else if (label == 'Size') {
                  _sizeFilter = result;
                }
              });
            }
          },
          child: Text(currentValue),
        ),
        if (showClearButton)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onReset,
          ),
      ],
    );
  }
}
