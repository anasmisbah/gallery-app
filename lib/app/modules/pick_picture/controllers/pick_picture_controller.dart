import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';

class PickPictureController extends GetxController {
  //TODO: Implement PickPictureController
  var pictures = List<AssetEntityImage>.empty().obs;
  List<AssetPathEntity> albums = List<AssetPathEntity>.empty();
  AssetPathEntity? path;

  RxString currentAlbumName = 'Semua Media'.obs;

  int currentPage = 0;
  late int lastPage;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getAlbum();
    scrollController.addListener(() {
      // print out the scroll offset
      print(
          scrollController.offset / scrollController.position.maxScrollExtent);
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (currentPage != lastPage) {
          fetchNewMedia();
        }
      }
    });
  }

  getAlbum({String? id}) async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.hasAccess) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      if (id == null) {
        path = albums.first;
      } else {
        path = albums.firstWhere((album) => album.id == id);
        currentAlbumName.value = path?.name ?? 'not Found';
      }
      currentPage = 0;
      pictures.clear();
      fetchNewMedia();
    }
  }

  fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermissionExtend();
    if (result.hasAccess) {
      int _totalEntitiesCount = await path!.assetCountAsync;
      final List<AssetEntity> entities = await path!.getAssetListPaged(
        page: lastPage,
        size: 35,
      );
      var temp = entities
          .map((e) => AssetEntityImage(
                e,
                fit: BoxFit.cover,
                isOriginal: false, // Defaults to `true`.
                thumbnailSize:
                    const ThumbnailSize.square(200), // Preferred value.
                thumbnailFormat: ThumbnailFormat.jpeg,
              ))
          .toList();
      pictures.addAll(temp);
      currentPage++;
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  openCropImage(AssetEntity entity, BuildContext context) async {
    var mediaUrl = await entity.file;
    // log(mediaUrl!.path);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: mediaUrl!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
  }
}
