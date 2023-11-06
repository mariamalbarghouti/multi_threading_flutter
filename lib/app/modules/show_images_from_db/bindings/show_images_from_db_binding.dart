import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/provider.dart';
import 'package:kids_care_demo/app/core/domain/repo.dart';
import 'package:kids_care_demo/app/core/infrastructure/provider/images_provider.dart';
import 'package:kids_care_demo/app/core/infrastructure/repo/images_repo.dart';
import 'package:kids_care_demo/app/modules/show_images_from_db/controllers/show_images_from_db_controller.dart';

class ShowImagesFromBDBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut<IImageProvider>(
      () => ImagesProviderImp(),
    );
    Get.lazyPut<IImagesRepo>(
      () => ImagesRepoImp(imagesProvider: Get.find()),
    );
    Get.put<ShowImagesFromBDController>(
      ShowImagesFromBDController(repo: Get.find()),
    );
  }
}
