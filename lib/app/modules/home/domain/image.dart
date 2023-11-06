import 'dart:io';
import 'dart:isolate';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/objects/image_info.dart';
import 'package:kids_care_demo/app/core/domain/repo.dart';
import 'package:kids_care_demo/app/modules/home/controllers/home_controller.dart';
import 'package:kids_care_demo/core/colored_print.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class ImageProcessing {
  // static List images = [];
  // static List<ImageFile> outPutUrl = [];
  // static int timeStamp;
  // static String path;
  // static String logoPath;

  static Future<void> upload(images) async {
    if (images.isNotEmpty) {
      coloredPrint("uploadToTheServerWithWaterMark");

      /// Dispatch

      /// put Water Mark
      // ;
      // Upload
    }
  }

  static Future<List<ImageFile>> putWaterMark(images) async {
    List<ImageFile> outPutUrl = [];
    for (int i = 0; i < images.length; i++) {
      coloredPrint("Size: ${images.elementAt(i).size}");
      String outPutLocation =
          "${Get.find<HomeController>().appDocDir?.path}/${Get.find<HomeController>().timeStamp}_${images.elementAt(i).name}";

      await FFmpegKit.execute(
              '-i ${images.elementAt(i).path} -i ${Get.find<HomeController>().logoPath} -filter_complex "[0]scale=iw*0.50:ih*0.50[out1];[1]scale=iw*0.50:ih*0.50[out2];[out1][out2]overlay=15:H-h-15" $outPutLocation')
          .then((session) async {
        if (ReturnCode.isSuccess(await session.getReturnCode())) {
          coloredPrint('Image processing completed successfully');
          outPutUrl.add(ImageFile(
            i.toString(),
            name:
                '${Get.find<HomeController>().timeStamp}_${images.elementAt(i).name}',
            extension: images.elementAt(i).extension,
            path: outPutLocation,
            bytes: await getImageSize(outPutLocation),
          ));
        } else {
          coloredPrint(
              'Image processing failed. Error: ${await session.getReturnCode()}');
        }
      });
    }
    return outPutUrl;
  }

  static Future<Uint8List> getImageSize(String imagePath) async {
    File imageFile = File(imagePath);
    return await imageFile.readAsBytes();
  }

  static Future<void> fetchImages(SendPort senderPort) async {
    final receiverPort = ReceivePort();
    senderPort.send(receiverPort.sendPort);
    PostInfo? postInfo;

    await for (var message in receiverPort) {
      coloredPrint("fetchImages: ${message.toString()}");
      if (message is PostInfo) {
        postInfo = message;
        await IImagesRepo.sendImages(postInfo: postInfo).then((value) {
          senderPort.send(value);
        });
      }
    }
  }

  uploadToServer() async {
    final ReceivePort receivePort = ReceivePort();
    var isolate = await Isolate.spawn(fetchImages, receivePort.sendPort);
    SendPort sendPort;
    receivePort.listen((message) async {
      coloredPrint(
          "uploadToTheServerWithWaterMark message ${message.toString()}");
      if (message is SendPort) {
        sendPort = message;
        sendPort
            .send(PostInfo(title: "Hello", images: (await putWaterMark([]))));
      } else if (message is bool) {
        coloredPrint("Message: $message");
        if (message) {
          Get.snackbar(
            "",
            "Images Added Successfully",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            "Error",
            "Error Happened Please Try Later",
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        isolate.kill();
      }
    });
  }
}
