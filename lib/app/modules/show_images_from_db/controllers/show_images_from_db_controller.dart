import 'dart:async';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/objects/post.dart';
import 'package:kids_care_demo/app/core/domain/repo.dart';

class ShowImagesFromBDController extends GetxController
    with StateMixin<List<Post>> {
  ShowImagesFromBDController({required this.repo});
  final IImagesRepo repo;
  bool isLoading = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _fetchData();
  }

  Future<void> _fetchData() async {
    change(null, status: RxStatus.loading());

    await repo.getImages().then((value) {
      if (value.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(value, status: RxStatus.success());
      }
    });
  }

  Future<void> deletePost({required String id}) async {
    if (isLoading) return;
    isLoading = true;
    await repo.deleteImage(id: id).then((value) async {
      if (value) {
        await _fetchData();
        Get.snackbar(
          "",
          "Images Deleted Successfully",
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
    });
  }
}
