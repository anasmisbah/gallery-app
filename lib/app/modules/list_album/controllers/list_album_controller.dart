import 'dart:developer';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class ListAlbumController extends GetxController {
  var loading = false.obs;
  var albums = List<AssetPathEntity>.empty().obs;

  @override
  void onInit() {
    fetchAllAlbums();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  fetchAllAlbums() async {
    loading.value = true;
    var result = await PhotoManager.requestPermissionExtend();
    if (result.hasAccess) {
      List<AssetPathEntity> resAlbums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          containsPathModified: true,
          orders: <OrderOption>[OrderOption(type: OrderOptionType.createDate)],
        ),
      );
      albums.addAll(resAlbums);
      log(resAlbums.toString());
      loading.value = false;
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }
}
