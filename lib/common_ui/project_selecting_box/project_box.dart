import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class ProjectBox extends StatelessWidget {
  final String mainImage;
  final String projectName;
  final String logoImage;
  const ProjectBox({
    super.key,
    required this.logoImage,
    required this.mainImage,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 242,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(mainImage),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Expanded(
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(logoImage),
                      w20,
                      Container(
                        width: 1,
                        height: 70,
                        color: background,
                      ),
                      w20,
                      Text(
                        projectName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color.fromARGB(255, 47, 73, 34),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
