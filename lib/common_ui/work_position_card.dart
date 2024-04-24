import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

class WorkPositionCard extends StatelessWidget {
  final String positionName;
  final int salary;
  final String description;

  const WorkPositionCard({
    super.key,
    required this.description,
    required this.positionName,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10).copyWith(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  positionName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'от $salary рублей.',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(34, 0, 0, 0),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      )
                    ],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      width: 1,
                      color: greyf1,
                    ),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.phone,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              h10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
