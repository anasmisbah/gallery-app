import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class ShowPictureController extends GetxController {
  //TODO: Implement ShowPictureController

  

  final count = 0.obs;

  RxBool loading = false.obs;
  @override
  void onInit() {
    showPhoto();
    super.onInit();
  }

  showPhoto() async {
    loading.value = true;
    loading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
