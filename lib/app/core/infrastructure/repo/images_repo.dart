import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/objects/post.dart';
import 'package:kids_care_demo/app/core/domain/provider.dart';
import 'package:kids_care_demo/app/core/domain/repo.dart';
import 'package:kids_care_demo/core/colored_print.dart';

class ImagesRepoImp implements IImagesRepo {
  const ImagesRepoImp({required this.imagesProvider});
  final IImageProvider imagesProvider;

  @override
  Future<bool> deleteImage({required String id}) async {
    try {
      Response<int> _imagesProvider = await imagesProvider.deleteImage(id: id);

      if (_imagesProvider.isOk && _imagesProvider.body == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      coloredPrint("Error $e");
      return false;
    }
  }

  @override
  Future<List<Post>> getImages() async {
    try {
      Response<List<Post>> _imagesProvider = await imagesProvider.getImages();
      if (_imagesProvider.isOk) {
        return _imagesProvider.body!;
      } else {
        return [];
      }
    } catch (e) {
      coloredPrint("Error $e");
      return [];
    }
  }

  // @override
  // Future<bool> sendImages({
  //   required PostInfo postInfo,
  // }) async {
  //   try {
  //     Response<String> _imagesProvider = await IImageProvider.sendImages(
  //       postInfo: postInfo,
  //       httpClient: GetHttpClient(baseUrl: BASE_URL),
  //     );
  //     // Response<String> _imagesProvider =
  //     //     await compute(imagesProvider.sendImages, postInfo);
  //     if (_imagesProvider.isOk && _imagesProvider.body == "200") {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     coloredPrint("Error $e");
  //     return false;
  //   }
  // }
  
}
