import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/modules/water_marked/controllers/water_marked_controller.dart';

class WaterMarkedBody extends GetView<WaterMarkedController> {
  const WaterMarkedBody({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => Column(children: [
              Text("Count ${state?.length ?? 0}"),
              Flexible(
                child: ListView.builder(
                  itemCount: state?.length,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(9),
                  itemBuilder: (context, index) => Column(children: [
                    Image(
                      image: FileImage(File(state?[index].path ?? "")),
                    ),
                    Text("${state?[index].size ?? 0} Bytes")
                  ]),
                ),
              ),
              TextButton(
                  onPressed: () async => await controller.uploadImages(),
                  child: GetBuilder<WaterMarkedController>(
                      id: "loading",
                      builder: (controller) {
                        return controller.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const Text("Upload Images");
                      })),
            ]),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text("No Data")));
  }
}
