import 'package:get/get.dart';

import '../controllers/open_camera_controller.dart';

class OpenCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpenCameraController>(
      () => OpenCameraController(),
    );
  }
}
