import 'package:firebase_base/controller/homeScreenController.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeScreenController>(HomeScreenController());
  }
}