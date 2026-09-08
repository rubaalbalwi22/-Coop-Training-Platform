import 'package:train_link/core/utils/size_utils.dart';

import '../../core/app_export.dart';
   import 'controller/splash_controller.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.secondaryContainer,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5.v),
              CustomImageView(
                imagePath: ImageConstant.imgLogo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
