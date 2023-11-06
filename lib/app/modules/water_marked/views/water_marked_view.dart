import 'package:flutter/material.dart';
import 'package:kids_care_demo/app/modules/water_marked/views/widgets/water_marked_body.dart';


class WaterMarkedView extends StatelessWidget {
  const WaterMarkedView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WaterMarked Images'),
        centerTitle: true,
      ),
      body: const WaterMarkedBody(),
    );
  }
}
