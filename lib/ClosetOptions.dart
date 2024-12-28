class ClosetOptions {
  static List<String> clothingTypes = ['Shirt', 'Pants', 'Dress', 'Jacket'];
  static List<String> colors = ['Red', 'Blue', 'Green', 'Black', 'White'];
  static List<String> attires = ['Formal', 'Casual', 'Sportswear'];
  static List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL']; // Added Sizes

  // Method to add an option to the list if it doesn't already exist
  static void addOption(List<String> list, String newOption) {
    if (!list.contains(newOption)) {
      list.add(newOption);
    }
  }

  // Returns the options list for a given filter (Clothing Type, Color, Attire, Size)
  static List<String> getOptionsForFilter(String filter) {
    switch (filter) {
      case 'Clothing Type':
        return clothingTypes;
      case 'Color':
        return colors;
      case 'Attire':
        return attires;
      case 'Size':
        return sizes;
      default:
        return [];
    }
  }

  // Returns the default option for each filter
  static String getDefaultOption(String filter) {
    switch (filter) {
      case 'Clothing Type':
        return 'Clothing Type';
      case 'Color':
        return 'Color';
      case 'Attire':
        return 'Attire';
      case 'Size':
        return 'S'; // Default size is 'S'
      default:
        return '';
    }
  }
}
