import 'package:flutter/material.dart';
import 'package:galler_app/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.OPEN_CAMERA);
              },
              child: Text("Open camera"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.PICK_PICTURE);
              },
              child: Text("Open gallery"),
            ),
          ],
        ),
      ),
    );
  }
}
