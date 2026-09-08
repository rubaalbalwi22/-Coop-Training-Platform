import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/size_utils.dart';
import 'package:train_link/theme/theme_helper.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(
              5.h,
            ),
          ),
        ),
      );
  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        elevation: WidgetStateProperty.all<double>(0),
      );
}
