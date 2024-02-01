import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
    BuildContext context, String errorText, AnimatedSnackBarType type) {
  AnimatedSnackBar.material(
    errorText,
    type: type,
  ).show(context);
}
