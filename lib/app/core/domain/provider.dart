import 'dart:io';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:kids_care_demo/app/core/constants.dart';
import 'package:kids_care_demo/app/core/domain/objects/image_info.dart';
import 'package:kids_care_demo/app/core/domain/objects/post.dart';
import 'package:kids_care_demo/core/colored_print.dart';

abstract class IImageProvider {
  Future<Response<int>> deleteImage({required String id});
  Future<Response<List<Post>>> getImages();
  static Future<Response<String>> sendImages({
    required PostInfo postInfo,
    required GetHttpClient httpClient,
  }) async {
    httpClient.defaultDecoder = (value) {
      coloredPrint("value: ${value.toString()}");
      return value["posts"]["status"] as String;
    };
    Map<String, dynamic> fields = {
      'classIds[0]': '1',
      'title': postInfo.title,
    };
    for (int i = 0; i < postInfo.images.length; i++) {
      fields["file[$i]"] = MultipartFile(File(postInfo.images[i].path ?? ""),
          filename: postInfo.images[i].name);
    }
    return await httpClient.post(
      "nursery=chubbycheeks&type=insertFiles&format=json",
      body: FormData(fields),
    );
  }

  static void isolateEntry(dynamic message) {
    late SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((dynamic message) async {
      // assert(message is String);
      final client = GetHttpClient(baseUrl: BASE_URL);
      try {
        final articles =
            await sendImages(httpClient: client, postInfo: message);
        sendPort.send(articles);
      } finally {
        client.close();
      }
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }
}
