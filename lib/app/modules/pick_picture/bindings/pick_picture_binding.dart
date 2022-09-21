import 'package:get/get.dart';

import '../controllers/pick_picture_controller.dart';

class PickPictureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickPictureController>(
      () => PickPictureController(),
    );
  }
}
