import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class ClassicTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hintText;

  const ClassicTextField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
  });

  @override
  State<ClassicTextField> createState() => _ClassicTextFieldState();
}

class _ClassicTextFieldState extends State<ClassicTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontSize: 16,
            color: grey9,
          ),
          border: InputBorder.none,
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 23,
            color: grey4,
          ),
        ),
      ),
    );
  }
}
