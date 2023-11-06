import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/objects/image_info.dart';
import 'package:kids_care_demo/app/core/domain/repo.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'dart:async';

class WaterMarkedController extends GetxController
    with StateMixin<List<ImageFile>> {
  WaterMarkedController({required this.repo});
  final IImagesRepo repo;

  List<ImageFile> waterMarkedImages = [];
  int timeStamp = 0;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    waterMarkedImages = Get.arguments["images"];
    timeStamp = Get.arguments["time"];
    print("outPutUrl ${waterMarkedImages.length}");
    print("timeStamp $timeStamp");
    if (waterMarkedImages.isEmpty) {
      change(null, status: RxStatus.empty());
    } else {
      change(waterMarkedImages, status: RxStatus.success());
    }
  }

  Future<void> uploadImages() async {
    if (isLoading) return;
    isLoading = true;
    update(["loading"]);
    await IImagesRepo
        .sendImages(
      postInfo: PostInfo(
        title: "title_test",
        images: waterMarkedImages,
      ),
    )
        .then((value) async {
      if (value) {
        Get.back();
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
      isLoading = false;
      update(["loading"]);
    });
  }
}
