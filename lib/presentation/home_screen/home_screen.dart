import 'package:get/get.dart';
import 'package:ipix/presentation/home_screen/home_controller.dart';
import 'package:ipix/presentation/login_screen/login_screen.dart';
import 'package:ipix/services/shared_pref.dart';
import 'package:ipix/widgets/app_bar/custom_app_bar.dart';
import 'package:ipix/widgets/app_bar/appbar_trailing_image.dart';
import 'package:ipix/widgets/app_bar/appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:ipix/core/app_export.dart';
import 'package:ipix/widgets/restaurant_tile.dart';
import 'package:ipix/widgets/snackbar_messenger.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    RecommentedController recommentedController =
        Get.put(RecommentedController());

    return GetBuilder<RecommentedController>(
      builder: (controller) {
        return Scaffold(
          appBar: _buildAppBar(context),
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: controller.restaurants.isEmpty
              ? Center(
                  child: Text('Please wait'),
                )
              : Container(
                  width: SizeUtils.width,
                  height: SizeUtils.height,
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      return RedtsurantTileWidget(
                        controller.restaurants[index],
                      );
                    },
                    itemCount: controller.restaurants.length,
                    separatorBuilder: (_, index) {
                      return Divider(
                        height: 1,
                        color: Colors.grey.withOpacity(0.7),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: Text(
        "    RESTAURANTS",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      height: 50.h,
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgGroup32202,
          margin: EdgeInsets.only(
            left: 36.h,
            bottom: 3.v,
          ),
        ),
        AppbarTitle(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Confirm Log Out',
                  ),
                  content: Text(
                    'Are you sure you want to Log out?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.back(); // Dismiss the dialog
                      },
                      child: Text(
                        'Go back',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await SharedPref.instence.signout();

                        Get.showSnackbar(
                          getxSnackbar(
                            message: " Logged out",
                            isError: false,
                          ),
                        );
                        Get.offAll(() => LoginScreen());
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          text: "Log out",
          margin: EdgeInsets.only(
            top: 0.h,
            left: 9.h,
            right: 36.h,
          ),
        ),
      ],
    );
  }
}
