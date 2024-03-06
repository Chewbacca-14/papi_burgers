import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/auth_pages/pin_code_fields.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/controllers/login_controller.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:papi_burgers/controllers/timer_controller.dart';
import 'package:papi_burgers/views/refactored_pages/home_page.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginCodePage extends StatefulWidget {
  final String phoneNumber;
  const LoginCodePage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<LoginCodePage> createState() => _LoginCodePageState();
}

class _LoginCodePageState extends State<LoginCodePage> {
  Future<bool> isUserExists() async {
    CollectionReference<Map<String, dynamic>> _firestore =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await _firestore.where('phone', isEqualTo: widget.phoneNumber).get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  final TextEditingController _otpCodeController = TextEditingController();

  @override
  void initState() {
    TimerController timerController = context.read<TimerController>();
    timerController.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginController loginController = context.read<LoginController>();
    TimerController timerController =
        Provider.of<TimerController>(context, listen: true);
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Введите код \nподтверждения',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            h20,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "На ваш номер отправлен СМС с кодом подтверждения введите его здесь",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            h60,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: PinCodeFields(controller: _otpCodeController),
            ),
            h20,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: ClassicLongButton(
                onTap: () async {
                  if (_otpCodeController.text.length != 6) {
                    showCustomSnackBar(context, 'Введите полный код',
                        AnimatedSnackBarType.error);
                  } else if (_otpCodeController.text.isEmpty) {
                    showCustomSnackBar(
                        context, 'Введите код', AnimatedSnackBarType.error);
                  }
                  LoginCodeResult otpCodeResult = await loginController
                      .checkOTPCode(_otpCodeController.text);
                  switch (otpCodeResult) {
                    case LoginCodeResult.success:
                      bool isExists = await isUserExists();
                      context.mounted
                          ? isExists
                              ? context.router.push(HomeRoute())
                              : context.router.push(
                                  UserDetailsRoute(
                                      phoneNumber: widget.phoneNumber),
                                )
                          : null;
                      break;
                    case LoginCodeResult.wrongOTP:
                      context.mounted
                          ? showCustomSnackBar(context, 'Неверный код',
                              AnimatedSnackBarType.error)
                          : null;
                  }
                },
                buttonText: 'Войти',
              ),
            ),
            h20,
            GestureDetector(
              onTap: () async {
                if (timerController.canResendOTP) {
                  LoginResult loginResult =
                      await loginController.sentVerifyCode(
                    widget.phoneNumber.replaceAll('(', '').replaceAll(')', ''),
                  );
                  //+420 132457895
                  timerController.startTimer();
                } else {
                  showCustomSnackBar(
                      context,
                      'Пожалуйста, подождите ${timerController.seconds} сек.',
                      AnimatedSnackBarType.info);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  timerController.canResendOTP
                      ? 'Отправить снова'
                      : 'Не получили СМС? \nВы можете отправить запрос \nчерез ${timerController.seconds} сек.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
