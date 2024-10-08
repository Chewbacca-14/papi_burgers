import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/providers/firestore_db_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/classic_text_field.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:provider/provider.dart';

@RoutePage()
class UserDetailsPage extends StatefulWidget {
  final String phoneNumber;
  const UserDetailsPage({super.key, required this.phoneNumber});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirestoreDBProvider firestoreDBProvider =
        Provider.of<FirestoreDBProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkGrey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            const Text(
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
                          onTap: () async {
                            if (_nameController.text.isEmpty) {
                              showCustomSnackBar(
                                  context,
                                  'Пожалуйста введите имя',
                                  AnimatedSnackBarType.error);
                            } else {
                              try {
                                firestoreDBProvider.createUserInFirestore(
                                    nameController: _nameController,
                                    phoneNumber: widget.phoneNumber);
                                context.mounted
                                    ? context.router.push(HomeRoute())
                                    : null;
                              } catch (e) {
                                showCustomSnackBar(context, 'Ошибка $e',
                                    AnimatedSnackBarType.error);
                              }
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
