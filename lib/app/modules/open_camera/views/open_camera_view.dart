import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:galler_app/app/modules/open_camera/views/preview_screen.dart';
import 'package:galler_app/main.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../controllers/open_camera_controller.dart';

class OpenCameraView extends GetView<OpenCameraController>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    controller.handleChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  const OpenCameraView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenCameraView'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isCameraInitialized.isTrue
            ? AspectRatio(
                aspectRatio: 1 / controller.controller!.value.aspectRatio,
                child: Stack(
                  children: [
                    controller.controller!.buildPreview(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        8.0,
                        16.0,
                        8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: DropdownButton<ResolutionPreset>(
                                  dropdownColor: Colors.black87,
                                  underline: Container(),
                                  value:
                                      controller.currentResolutionPreset.value,
                                  items: [
                                    for (ResolutionPreset preset
                                        in controller.resolutionPresets)
                                      DropdownMenuItem(
                                        child: Text(
                                          preset
                                              .toString()
                                              .split('.')[1]
                                              .toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        value: preset,
                                      )
                                  ],
                                  onChanged: (value) {
                                    controller.currentResolutionPreset.value =
                                        value!;
                                    controller.isCameraInitialized.value =
                                        false;
                                    controller.onNewCameraSelected(
                                        controller.controller!.description);
                                  },
                                  hint: Text("Select item"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, top: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  controller.currentExposureOffset
                                          .toStringAsFixed(1) +
                                      'x',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Container(
                                height: 30,
                                child: Slider(
                                  value: controller.currentExposureOffset.value,
                                  min: controller.minAvailableExposureOffset,
                                  max: controller.maxAvailableExposureOffset,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white30,
                                  onChanged: (value) async {
                                    controller.currentExposureOffset.value =
                                        value;
                                    await controller.controller!
                                        .setExposureOffset(value);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: controller.currentZoomLevel.value,
                                  min: controller.minAvailableZoom,
                                  max: controller.maxAvailableZoom,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white30,
                                  onChanged: (value) async {
                                    controller.currentZoomLevel.value = value;
                                    await controller.controller!
                                        .setZoomLevel(value);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      controller.currentZoomLevel
                                              .toStringAsFixed(1) +
                                          'x',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: controller.isRecordingInProgress.value
                                    ? () async {
                                        if (controller.controller!.value
                                            .isRecordingPaused) {
                                          await controller
                                              .resumeVideoRecording();
                                        } else {
                                          await controller
                                              .pauseVideoRecording();
                                        }
                                      }
                                    : () {
                                        controller.isCameraInitialized.value =
                                            false;
                                        controller.onNewCameraSelected(cameras[
                                            controller
                                                    .isRearCameraSelected.value
                                                ? 1
                                                : 0]);
                                        controller.isRearCameraSelected.value =
                                            !controller
                                                .isRearCameraSelected.value;
                                      },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.black38,
                                      size: 60,
                                    ),
                                    controller.isRecordingInProgress.value
                                        ? controller.controller!.value
                                                .isRecordingPaused
                                            ? Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 30,
                                              )
                                            : Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                                size: 30,
                                              )
                                        : Icon(
                                            controller
                                                    .isRearCameraSelected.value
                                                ? Icons.camera_front
                                                : Icons.camera_rear,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: controller.isVideoCameraSelected.value
                                    ? () async {
                                        if (controller
                                            .isRecordingInProgress.value) {
                                          XFile? rawVideo = await controller
                                              .stopVideoRecording();
                                          File videoFile = File(rawVideo!.path);

                                          int currentUnix = DateTime.now()
                                              .millisecondsSinceEpoch;

                                          final directory =
                                              await getApplicationDocumentsDirectory();
                                          String fileFormat =
                                              videoFile.path.split('.').last;

                                          controller.videoFile.value =
                                              await videoFile.copy(
                                            '${directory.path}/$currentUnix.$fileFormat',
                                          );

                                          controller.startVideoPlayer();
                                        } else {
                                          await controller
                                              .startVideoRecording();
                                        }
                                      }
                                    : () async {
                                        XFile? rawImage =
                                            await controller.takePicture();
                                        File imageFile = File(rawImage!.path);

                                        int currentUnix = DateTime.now()
                                            .millisecondsSinceEpoch;
                                        final directory =
                                            await getApplicationDocumentsDirectory();
                                        String fileFormat =
                                            imageFile.path.split('.').last;

                                        await imageFile.copy(
                                          '${directory.path}/$currentUnix.$fileFormat',
                                        );
                                        controller.refreshAlreadyCapturedImages();
                                      },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color:
                                          controller.isVideoCameraSelected.value
                                              ? Colors.red
                                              : Colors.white,
                                      size: 80,
                                    ),
                                    controller.isVideoCameraSelected.value &&
                                            controller
                                                .isRecordingInProgress.value
                                        ? Icon(
                                            Icons.stop_rounded,
                                            color: Colors.white,
                                            size: 32,
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: controller.imageFile.value != null ||
                                        controller.videoFile.value != null
                                    ? () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PreviewScreen(
                                              imageFile:
                                                  controller.imageFile.value!,
                                              fileList: controller.allFileList,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    image: controller.imageFile.value != null
                                        ? DecorationImage(
                                            image: FileImage(
                                                controller.imageFile.value!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: controller.videoController != null &&
                                          controller.videoController!.value
                                              .isInitialized
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: AspectRatio(
                                            aspectRatio: controller
                                                .videoController!
                                                .value
                                                .aspectRatio,
                                            child: VideoPlayer(
                                                controller.videoController!),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 4.0,
                                  ),
                                  child: TextButton(
                                    onPressed:
                                        controller.isRecordingInProgress.value
                                            ? null
                                            : () {
                                                if (controller
                                                    .isVideoCameraSelected
                                                    .value) {
                                                  controller
                                                      .isVideoCameraSelected
                                                      .value = false;
                                                }
                                              },
                                    style: TextButton.styleFrom(
                                      primary:
                                          controller.isVideoCameraSelected.value
                                              ? Colors.black54
                                              : Colors.black,
                                      backgroundColor:
                                          controller.isVideoCameraSelected.value
                                              ? Colors.white30
                                              : Colors.white,
                                    ),
                                    child: Text('IMAGE'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      if (!controller
                                          .isVideoCameraSelected.value) {
                                        controller.isVideoCameraSelected.value =
                                            true;
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      primary:
                                          controller.isVideoCameraSelected.value
                                              ? Colors.black
                                              : Colors.black54,
                                      backgroundColor:
                                          controller.isVideoCameraSelected.value
                                              ? Colors.white
                                              : Colors.white30,
                                    ),
                                    child: Text('VIDEO'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    controller.currentFlashMode.value =
                                        FlashMode.off;
                                    await controller.controller!.setFlashMode(
                                      FlashMode.off,
                                    );
                                  },
                                  child: Icon(
                                    Icons.flash_off,
                                    color: controller.currentFlashMode.value ==
                                            FlashMode.off
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    controller.currentFlashMode.value =
                                        FlashMode.auto;
                                    await controller.controller!.setFlashMode(
                                      FlashMode.auto,
                                    );
                                  },
                                  child: Icon(
                                    Icons.flash_auto,
                                    color: controller.currentFlashMode.value ==
                                            FlashMode.auto
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    controller.currentFlashMode.value =
                                        FlashMode.always;
                                    await controller.controller!.setFlashMode(
                                      FlashMode.always,
                                    );
                                  },
                                  child: Icon(
                                    Icons.flash_on,
                                    color: controller.currentFlashMode.value ==
                                            FlashMode.always
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    controller.currentFlashMode.value =
                                        FlashMode.torch;
                                    await controller.controller!.setFlashMode(
                                      FlashMode.torch,
                                    );
                                  },
                                  child: Icon(
                                    Icons.highlight,
                                    color: controller.currentFlashMode.value ==
                                            FlashMode.torch
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
