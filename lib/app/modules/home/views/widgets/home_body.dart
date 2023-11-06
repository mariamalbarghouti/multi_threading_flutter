import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/modules/home/controllers/home_controller.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class HomeBody extends GetView<HomeController> {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      MultiImagePickerView(
        controller: controller.controller,
      ),
      const SizedBox(height: 30),
      TextButton(
        onPressed: () async => await controller.goToWaterMarkedPage(),
        child: const Text("Put Water Mark"),
      ),
      const SizedBox(height: 30),
      TextButton(
        onPressed: () async =>
            await controller.uploadToTheServerWithWaterMark(),
        child: GetBuilder<HomeController>(
            id: "loading",
            builder: (controller) {
              if (controller.isUploading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Text("Put Water Mark & Upload OneShoot");
              }
            }),
      ),
      const SizedBox(height: 30),
      TextButton(
        onPressed: () async => await controller.goToAllImages(),
        child: const Text("Uploaded Images"),
      ),
    ]);
  }
}
