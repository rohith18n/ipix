import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipix/core/app_export.dart';
import 'package:ipix/presentation/home_screen/home_screen.dart';
import 'package:ipix/services/shared_pref.dart';
import 'package:ipix/widgets/custom_text_form_field.dart';
import 'package:ipix/widgets/custom_checkbox_button.dart';
import 'package:ipix/widgets/custom_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberme = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgGroup30856,
                    height: 229.v,
                  ),
                  SizedBox(height: 38.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 21.h),
                      child: Text(
                        "Log in\nyour account",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall!.copyWith(
                          height: 1.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.v),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.h),
                    child: CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      autofocus: false,
                      controller: userNameController,
                      hintText: "User Name",
                    ),
                  ),
                  SizedBox(height: 22.v),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.h),
                    child: CustomTextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      autofocus: false,
                      controller: passwordController,
                      hintText: "Password",
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      suffix: Container(
                        margin: EdgeInsets.fromLTRB(30.h, 12.v, 14.h, 12.v),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgEyeslash1,
                          height: 20.v,
                        ),
                      ),
                      suffixConstraints: BoxConstraints(
                        maxHeight: 45.v,
                      ),
                      obscureText: true,
                      contentPadding: EdgeInsets.only(
                        left: 16.h,
                        top: 14.v,
                        bottom: 14.v,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 23.h,
                      right: 25.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRememberme(context),
                        Text(
                          "Forgot password?",
                          style: CustomTextStyles.titleSmallRobotoOnPrimary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 91.v),
                  CustomElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!rememberme) {
                          Get.defaultDialog(
                            title: 'Alert',
                            middleText: 'Please accept "Remember me"',
                            confirm: TextButton(
                              onPressed: () => Get.back(),
                              child: Text('OK'),
                            ),
                          );
                          return;
                        }
                        await SharedPref.instence
                            .setName(userNameController.text);
                        Get.off(() => HomeScreen());
                      }
                    },
                    text: "Login",
                    margin: EdgeInsets.symmetric(horizontal: 23.h),
                  ),
                  SizedBox(height: 7.v),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberme(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.v),
      child: CustomCheckboxButton(
        text: "Remember me",
        value: rememberme,
        onChange: (value) {
          setState(() {
            rememberme = value;
          });
        },
      ),
    );
  }
}
