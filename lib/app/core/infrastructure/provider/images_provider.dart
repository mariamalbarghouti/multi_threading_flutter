import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/domain/objects/post.dart';
import 'package:kids_care_demo/app/core/domain/provider.dart';
import 'package:kids_care_demo/app/core/infrastructure/provider/api_provider.dart';
import 'package:kids_care_demo/core/colored_print.dart';

class ImagesProviderImp extends BaseProvider implements IImageProvider {
  @override
  void onClose() {}

  // @override
  // Future<Response<String>> sendImages({
  //   required PostInfo postInfo,
  // }) async {
  //   httpClient.defaultDecoder = (value) {
  //     return value["posts"]["status"] as String;
  //   };
  //   Map<String, dynamic> fields = {
  //     'classIds[0]': '1',
  //     'title': postInfo.title,
  //   };
  //   for (int i = 0; i < postInfo.images.length; i++) {
  //     fields["file[$i]"] =
  //         MultipartFile(File(postInfo.images[i].path ?? ""), filename: postInfo.images[i].name);
  //   }
  //   return await httpClient.post(
  //     "nursery=chubbycheeks&type=insertFiles&format=json",
  //     body: FormData(fields),
  //   );
  // }

  @override
  Future<Response<int>> deleteImage({required String id}) async {
    httpClient.defaultDecoder = (value) {
      coloredPrint("value: ${value.toString()}");
      return (value["posts"] as List).first as int;
    };
    return await httpClient
        .get("format=json&nursery=chubbycheeks&type=deletefile&id=$id");
  }

  @override
  Future<Response<List<Post>>> getImages() async {
    httpClient.defaultDecoder = (value) {
      coloredPrint("value: ${value.toString()}");
      try {
        return List<Post>.from(
          (value["posts"] as Iterable).map(
            (map) => Post.fromJson(map),
          ),
        );
      } catch (e) {
        coloredPrint("Error: $e");
        return List<Post>.empty();
      }
    };
    return await httpClient
        .get("format=json&nursery=chubbycheeks&type=listfiles2");
  }
}
