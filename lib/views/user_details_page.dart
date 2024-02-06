import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/classic_text_field.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';

@RoutePage()
class UserDetailsPage extends StatefulWidget {
  final String phoneNumber;
  const UserDetailsPage({super.key, required this.phoneNumber});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final TextEditingController _nameController = TextEditingController();

  Future<bool> createUserInFirestoreAndCheckIFExists() async {
   CollectionReference<Map<String, dynamic>> _firestore = FirebaseFirestore.instance.collection('users');
QuerySnapshot querySnapshot = await _firestore.where('phone', isEqualTo: widget.phoneNumber).get();
  if(querySnapshot.docs.isNotEmpty) {

    return true;
  } else {
     await _firestore.add({
      'name': _nameController.text,
      'phone': widget.phoneNumber,
    });
    return false;
  }
   
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkGrey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              'Профиль',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 110,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      h60,
                      ClassicTextField(
                        controller: _nameController,
                        prefixIcon: Icons.person,
                        hintText: 'Имя',
                      ),
                      h60,
                      ClassicLongButton(
                          onTap: () {
                            if (_nameController.text.isEmpty) {
                              showCustomSnackBar(
                                  context,
                                  'Пожалуйста введите имя',
                                  AnimatedSnackBarType.error);
                            } else {
                              createUserInFirestore();
                              context.mounted
                                  ? context.router.push(const HomeRoute())
                                  : null;
                            }
                          },
                          buttonText: 'Сохранить')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
