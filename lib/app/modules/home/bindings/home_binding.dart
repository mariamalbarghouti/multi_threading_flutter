import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/provider.dart';
import 'package:kids_care_demo/app/core/domain/repo.dart';
import 'package:kids_care_demo/app/core/infrastructure/provider/images_provider.dart';
import 'package:kids_care_demo/app/core/infrastructure/repo/images_repo.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IImageProvider>(
      () => ImagesProviderImp(),
    );
    Get.lazyPut<IImagesRepo>(
      () => ImagesRepoImp(imagesProvider: Get.find()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(repo: Get.find()),
    );
  }
}
