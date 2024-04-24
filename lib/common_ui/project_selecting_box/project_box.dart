import 'package:flutter/material.dart';

class ProjectBox extends StatelessWidget {
  final String mainImage;
  final String projectName;
  final String logoImage;

  const ProjectBox({
    Key? key,
    required this.logoImage,
    required this.mainImage,
    required this.projectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 242,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // image: DecorationImage(
          //     image: NetworkImage(mainImage), fit: BoxFit.cover),
        ),
        child: Center(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/bg.png',
                  image: mainImage,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: const Alignment(0, 0.787),
                  child: Container(
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                image: NetworkImage(logoImage),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            color: const Color.fromARGB(132, 158, 158, 158),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 8,
                            child: Text(
                              projectName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 17, 17, 17),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
