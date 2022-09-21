import 'package:get/get.dart';

import '../controllers/list_album_controller.dart';

class ListAlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListAlbumController>(
      () => ListAlbumController(),
    );
  }
}
