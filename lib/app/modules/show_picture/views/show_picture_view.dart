import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../controllers/show_picture_controller.dart';

class ShowPictureView extends GetView<ShowPictureController> {
  const ShowPictureView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShowPictureView'),
        centerTitle: true,
      ),
      body: SizedBox(),
    );
  }
}
