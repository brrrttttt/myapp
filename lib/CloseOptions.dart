// ClosetOptions.dart
class ClosetOptions {
  static List<String> clothingTypes = ['Shirt', 'Pants', 'Dress', 'Jacket'];
  static List<String> colors = ['Red', 'Blue', 'Green', 'Black', 'White'];
  static List<String> attires = ['Formal', 'Casual', 'Sportswear'];

  static void addOption(List<String> list, String newOption) {
    if (!list.contains(newOption)) {
      list.add(newOption);
    }
  }
}
