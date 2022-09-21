import 'package:get/get.dart';

import '../controllers/show_picture_controller.dart';

class ShowPictureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowPictureController>(
      () => ShowPictureController(),
    );
  }
}
