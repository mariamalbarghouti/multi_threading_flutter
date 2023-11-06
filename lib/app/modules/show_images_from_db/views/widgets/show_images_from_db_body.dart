import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/modules/show_images_from_db/controllers/show_images_from_db_controller.dart';

class ShowImagesFromBDBody extends GetView<ShowImagesFromBDController> {
  const ShowImagesFromBDBody({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => ListView.builder(
              itemCount: state?.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(9),
              itemBuilder: (context, index) => Column(children: [
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    enableInfiniteScroll: false,
                    aspectRatio: 2 / 3,
                  ),
                  items: state?[index].files.map((e) {
                    return Image.network(
                      e.file,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 48.0,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Row(children: [
                  IconButton(
                    onPressed: () async =>
                        await controller.deletePost(id: state?[index].id ?? ""),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "Date: ${state?[index].date ?? ""}",
                    textAlign: TextAlign.start,
                  ),
                ]),
              ]),
            ),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No Data")));
  }
}
