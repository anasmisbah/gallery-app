import 'package:flutter/material.dart';
import 'package:galler_app/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../controllers/pick_picture_controller.dart';

class PickPictureView extends GetView<PickPictureController> {
  const PickPictureView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PickPictureView'),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: [
            InkWell(
              onTap: () async {
                var res = await Get.toNamed(Routes.LIST_ALBUM);
                if (res != null) {
                  controller.getAlbum(id: res);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      controller.currentAlbumName.value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: controller.scrollController,
                itemCount: controller.pictures.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        controller.openCropImage(
                            controller.pictures[index].entity, context);
                      },
                      child: controller.pictures[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
