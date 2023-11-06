import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/constants.dart';
import 'package:kids_care_demo/app/core/domain/objects/image_info.dart';
import 'package:kids_care_demo/app/core/domain/objects/post.dart';
import 'package:kids_care_demo/app/core/domain/provider.dart';
import 'package:kids_care_demo/core/colored_print.dart';

abstract class IImagesRepo {
  Future<bool> deleteImage({required String id});
  Future<List<Post>> getImages();

  static Future<bool> sendImages({
    required PostInfo postInfo,
  }) async {
    try {
      Response<String> _imagesProvider = await IImageProvider.sendImages(
        postInfo: postInfo,
        httpClient: GetHttpClient(baseUrl: BASE_URL),
      );
      if (_imagesProvider.isOk && _imagesProvider.body == "200") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      coloredPrint("Error $e");
      return false;
    }
  }
}
