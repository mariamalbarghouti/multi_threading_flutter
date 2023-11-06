
import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/constants.dart';

/// for initialize the server url
class BaseProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = BASE_URL;
    httpClient.timeout = const Duration(seconds: 15);
  }
}
