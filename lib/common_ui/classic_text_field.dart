import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

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
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 23,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LightTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hintText;
  final double size;
  const LightTextField(
      {super.key,
      required this.controller,
      required this.prefixIcon,
      required this.hintText,
      this.size = 48});

  @override
  State<LightTextField> createState() => _LightTextFieldState();
}

class _LightTextFieldState extends State<LightTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: greyf1),
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

class LightContainerField extends StatefulWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hintText;
  final void Function()? onTap;
  const LightContainerField(
      {super.key,
      required this.controller,
      required this.prefixIcon,
      required this.hintText,
      required this.onTap});

  @override
  State<LightContainerField> createState() => _LightContainerFieldState();
}

class _LightContainerFieldState extends State<LightContainerField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 250, 250),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1, color: greyf1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Row(
              children: [
                Icon(
                  widget.prefixIcon,
                  size: 23,
                  color: grey4,
                ),
                w12,
                Expanded(
                  child: Text(
                    widget.hintText,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
