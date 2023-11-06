import 'package:get/get.dart';
import 'package:kids_care_demo/app/modules/home/bindings/home_binding.dart';
import 'package:kids_care_demo/app/modules/home/views/home_view.dart';
import 'package:kids_care_demo/app/modules/show_images_from_db/bindings/show_images_from_db_binding.dart';
import 'package:kids_care_demo/app/modules/show_images_from_db/views/show_images_from_db_view.dart';
import 'package:kids_care_demo/app/modules/water_marked/bindings/water_marked_binding.dart';
import 'package:kids_care_demo/app/modules/water_marked/views/water_marked_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.WATER_MARKED,
      page: () => const WaterMarkedView(),
      binding: WaterMarkedBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_IMAGES_FROM_DB,
      page: () => const ShowImagesFromBDView(),
      binding: ShowImagesFromBDBinding(),
    ),
  ];
}
