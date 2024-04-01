import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipix/core/app_export.dart';
import 'package:ipix/presentation/home_screen/home_controller.dart';
import 'package:ipix/presentation/home_screen/home_screen.dart';
import 'package:ipix/presentation/login_screen/login_screen.dart';
import 'package:ipix/services/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: CustomImageView(
          imagePath: ImageConstant.imgTheGrandMarche,
          height: 90.v,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Future<void> navigateToLoginScreen() async {
    final name = SharedPref.instence.getName();
    log(name ?? "empty name");

    if (name != null) {
      await Get.put(RecommentedController()).fetchRestaurants();
      //  await Get.find<LoginController>.
      await Future.delayed(const Duration(seconds: 3));
      Get.off(() => const HomeScreen());
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Get.off(() => LoginScreen());
    }
  }
}
