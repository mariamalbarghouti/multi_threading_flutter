import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/provider.dart';
import 'package:kids_care_demo/app/core/domain/repo.dart';
import 'package:kids_care_demo/app/core/infrastructure/provider/images_provider.dart';
import 'package:kids_care_demo/app/core/infrastructure/repo/images_repo.dart';
import 'package:kids_care_demo/app/modules/water_marked/controllers/water_marked_controller.dart';

class WaterMarkedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IImageProvider>(
      () => ImagesProviderImp(),
    );
    Get.lazyPut<IImagesRepo>(
      () => ImagesRepoImp(imagesProvider: Get.find()),
    );
    Get.lazyPut<WaterMarkedController>(
      () => WaterMarkedController(repo: Get.find()),
    );
  }
}
