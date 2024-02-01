import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeFields extends StatelessWidget {
  final TextEditingController controller;
  const PinCodeFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: controller,
      appContext: context,
      length: 6,
      autoDismissKeyboard: false,
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      cursorColor: Colors.grey,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          disabledBorderWidth: 0,
          borderRadius: BorderRadius.circular(8),
          errorBorderColor: Colors.black,
          selectedFillColor: const Color.fromARGB(48, 47, 73, 34),
          activeFillColor: const Color.fromARGB(48, 47, 73, 34),
          borderWidth: 0,
          activeBorderWidth: 0,
          inactiveFillColor: const Color.fromARGB(255, 211, 211, 211),
          selectedBorderWidth: 0,
          activeColor: Colors.transparent,
          inactiveColor: Colors.transparent,
          fieldHeight: 40,
          fieldWidth: 40),
    );
  }
}
