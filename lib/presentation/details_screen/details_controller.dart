import 'package:get/get.dart';

class ReviewController extends GetxController {
  // Map to store the expansion status of each review
  RxMap<int, bool> reviewExpansionMap = <int, bool>{}.obs;
  bool showAllDays = false;

  // Method to toggle the expansion status of a review
  void toggleExpansion(int index) {
    if (reviewExpansionMap.containsKey(index)) {
      reviewExpansionMap[index] = !reviewExpansionMap[index]!;
    } else {
      reviewExpansionMap[index] = true;
    }
    update(); // Notify listeners about the change
  }

  void toggleAllDays() {
    showAllDays = !showAllDays;
    update();
  }
}
