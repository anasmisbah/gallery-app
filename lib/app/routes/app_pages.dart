import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/list_album/bindings/list_album_binding.dart';
import '../modules/list_album/views/list_album_view.dart';
import '../modules/open_camera/bindings/open_camera_binding.dart';
import '../modules/open_camera/views/open_camera_view.dart';
import '../modules/pick_picture/bindings/pick_picture_binding.dart';
import '../modules/pick_picture/views/pick_picture_view.dart';
import '../modules/show_picture/bindings/show_picture_binding.dart';
import '../modules/show_picture/views/show_picture_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PICK_PICTURE,
      page: () => const PickPictureView(),
      binding: PickPictureBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_PICTURE,
      page: () => const ShowPictureView(),
      binding: ShowPictureBinding(),
    ),
    GetPage(
      name: _Paths.OPEN_CAMERA,
      page: () => const OpenCameraView(),
      binding: OpenCameraBinding(),
    ),
    GetPage(
      name: _Paths.LIST_ALBUM,
      page: () => const ListAlbumView(),
      binding: ListAlbumBinding(),
    ),
  ];
}
