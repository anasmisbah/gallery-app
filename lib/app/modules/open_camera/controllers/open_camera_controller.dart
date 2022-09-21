import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:galler_app/main.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class OpenCameraController extends GetxController {
  //TODO: Implement OpenCameraController

  CameraController? controller;
  VideoPlayerController? videoController;

  RxBool isCameraInitialized = false.obs;
  RxBool isRearCameraSelected = true.obs;
  RxBool isVideoCameraSelected = false.obs;
  RxBool isRecordingInProgress = false.obs;

  Rx<FlashMode> currentFlashMode = FlashMode.auto.obs;
  var currentResolutionPreset = ResolutionPreset.high.obs;

  final resolutionPresets = ResolutionPreset.values;

  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;
  RxDouble currentZoomLevel = 1.0.obs;

  double minAvailableExposureOffset = 0.0;
  double maxAvailableExposureOffset = 0.0;
  RxDouble currentExposureOffset = 0.0.obs;

  Rx<File?> imageFile = File('').obs;
  Rx<File?> videoFile = File('').obs;

  RxList<File> allFileList = <File>[].obs;

  @override
  void onInit() {
    onNewCameraSelected(cameras[0]);
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset.value,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    controller = cameraController;

    // Update UI if controller updated
    cameraController.addListener(() {});

    // Initialize controller
    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => minAvailableZoom = value),
      ]);

      currentFlashMode.value = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    isCameraInitialized.value = controller!.value.isInitialized;
  }

  void handleChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;
    if (controller!.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return;
    }
    try {
      await cameraController!.startVideoRecording();
      isRecordingInProgress.value = true;
      print(isRecordingInProgress.value);
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Recording is already is stopped state
      return null;
    }
    try {
      XFile file = await controller!.stopVideoRecording();

      isRecordingInProgress.value = false;
      print(isRecordingInProgress.value);
      return file;
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Video recording is not in progress
      return;
    }
    try {
      await controller!.pauseVideoRecording();
    } on CameraException catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // No video recording was in progress
      return;
    }
    try {
      await controller!.resumeVideoRecording();
    } on CameraException catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  Future<void> startVideoPlayer() async {
    if (videoFile != null) {
      videoController = VideoPlayerController.file(videoFile.value!);
      await videoController!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
      });
      await videoController!.setLooping(true);
      await videoController!.play();
    }
  }

  refreshAlreadyCapturedImages() async {
    // Get the directory
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();

    List<Map<int, dynamic>> fileNames = [];

    // Searching for all the image and video files using
    // their default format, and storing them
    fileList.forEach((file) {
      if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
        allFileList.add(File(file.path));

        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    });

    // Retrieving the recent file
    if (fileNames.isNotEmpty) {
      final recentFile =
          fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      // Checking whether it is an image or a video file
      if (recentFileName.contains('.mp4')) {
        videoFile.value = File('${directory.path}/$recentFileName');
        startVideoPlayer();
      } else {
        imageFile.value = File('${directory.path}/$recentFileName');
      }
    }
  }
}
