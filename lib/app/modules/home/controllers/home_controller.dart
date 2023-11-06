import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/objects/image_info.dart';
import 'package:kids_care_demo/app/core/domain/repo.dart';
import 'package:kids_care_demo/app/routes/app_pages.dart';
import 'package:kids_care_demo/core/colored_print.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  HomeController({required this.repo});
  final IImagesRepo repo;
  List<ImageFile> _outPutUrl = [];
  bool isUploading = false;

  String logoPath = "";
  Directory? appDocDir;
  int timeStamp = 0;
  MultiImagePickerController controller = MultiImagePickerController(
    maxImages: 100,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
    withData: true,
    withReadStream: true,
    // images: <ImageFile>[] // array of pre/default selected images
  );
  @override
  Future<void> onInit() async {
    super.onInit();
    appDocDir = await getApplicationDocumentsDirectory();
    logoPath = await _getLocalPathForAsset('assets/logo.png');
    timeStamp = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }

  Future<void> _copyAssetToStorage(String assetPath, String outputPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    await File(outputPath).writeAsBytes(bytes, flush: true);
  }

  Future<String> _getLocalPathForAsset(String assetPath) async {
    final filePath = '${appDocDir?.path}/${assetPath.split('/').last}';
    final file = File(filePath);

    if (!file.existsSync()) {
      await _copyAssetToStorage(assetPath, filePath);
    }

    return filePath;
  }

  Future<void> _putWaterMark() async {
    for (int i = 0; i < controller.images.length; i++) {
      coloredPrint("Size: ${controller.images.elementAt(i).size}");
      String outPutLocation =
          "${appDocDir?.path}/${timeStamp}_${controller.images.elementAt(i).name}";

      await FFmpegKit.execute(
              '-i ${controller.images.elementAt(i).path} -i $logoPath -filter_complex "[0]scale=iw*0.50:ih*0.50[out1];[1]scale=iw*0.50:ih*0.50[out2];[out1][out2]overlay=15:H-h-15" $outPutLocation')
          .then((session) async {
        if (ReturnCode.isSuccess(await session.getReturnCode())) {
          coloredPrint('Image processing completed successfully');
          _outPutUrl.add(ImageFile(
            i.toString(),
            name: '${timeStamp}_${controller.images.elementAt(i).name}',
            extension: controller.images.elementAt(i).extension,
            path: outPutLocation,
            bytes: await getImageSize(outPutLocation),
          ));
        } else {
          coloredPrint(
              'Image processing failed. Error: ${await session.getReturnCode()}');
        }
      });
    }
  }

  Future<Uint8List> getImageSize(String imagePath) async {
    File imageFile = File(imagePath);
    return await imageFile.readAsBytes();
  }

  Future<void> goToWaterMarkedPage() async {
    if (controller.images.isNotEmpty) {
      await _putWaterMark().then(
        (_) async => await Get.toNamed(Routes.WATER_MARKED, arguments: {
          "images": _outPutUrl,
          "time": timeStamp,
        }),
      );
    }
  }

  Future<void> goToAllImages() async {
    await Get.toNamed(Routes.SHOW_IMAGES_FROM_DB);
  }

  Future<void> uploadToTheServerWithWaterMark() async {
    if (isUploading) return;
    isUploading = true;
    update(["loading"]);
    if (controller.images.isNotEmpty) {
      coloredPrint("uploadToTheServerWithWaterMark");
      final stopwatch = Stopwatch()..start();

      await _putWaterMark().then((value) async {
        final ReceivePort receivePort = ReceivePort();
        var isolate =
            await Isolate.spawn(sendImagesUsingIsolate, receivePort.sendPort);
        SendPort sendPort;
        receivePort.listen((message) {
          coloredPrint(
              "uploadToTheServerWithWaterMark message ${message.toString()}");
          if (message is SendPort) {
            sendPort = message;
            sendPort.send(PostInfo(title: "Hello", images: _outPutUrl));
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
            isUploading = false;
            controller.clearImages();
            update(["loading"]);
            stopwatch.stop();
            print('Function took ${stopwatch.elapsedMilliseconds} ms');
          }
        });
      });
    }
  }

  static Future<void> sendImagesUsingIsolate(SendPort senderPort) async {
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
}
