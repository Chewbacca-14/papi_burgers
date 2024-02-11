import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class ClassicLongButton extends StatelessWidget {
  final void Function()? onTap;
  final String buttonText;
  final bool showRightArrow;
  const ClassicLongButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.showRightArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  showRightArrow
                      ? const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
