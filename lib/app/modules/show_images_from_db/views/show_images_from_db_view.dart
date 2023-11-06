import 'package:flutter/material.dart';

import 'package:kids_care_demo/app/modules/show_images_from_db/views/widgets/show_images_from_db_body.dart';

class ShowImagesFromBDView extends StatelessWidget {
  const ShowImagesFromBDView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WaterMarked Images DB'),
        centerTitle: true,
      ),
      body: const ShowImagesFromBDBody(),
    );
  }
}
