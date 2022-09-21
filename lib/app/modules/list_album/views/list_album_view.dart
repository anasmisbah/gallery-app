import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/list_album_controller.dart';

class ListAlbumView extends GetView<ListAlbumController> {
  const ListAlbumView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListAlbumView'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
            itemBuilder: (context, index) {
              var album = controller.albums[index];

              return ListTile(
                title: Text(album.name),
                trailing: Text(
                  album.lastModified.toString(),
                ),
                onTap: () {
                  Get.back(result: album.id);
                },
              );
            },
            itemCount: controller.albums.length),
      ),
    );
  }
}
