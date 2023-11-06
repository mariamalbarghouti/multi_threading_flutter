import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kids_care_demo/app/modules/home/views/widgets/home_body.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: const HomeBody(),
    );
  }
}
