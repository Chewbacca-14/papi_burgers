import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/controllers/login_controller.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool isAgree = false;
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

 

  @override
  Widget build(BuildContext context) {
    LoginController loginController = context.read<LoginController>();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Введите номер \nтелефона",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                h20,
                const Text(
                  "На него придет СМС \nс кодом подтверждения",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                h60,
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 246, 246),
                      borderRadius: BorderRadius.circular(16)),
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: '+ 7 (ХХХ) ХХХ ХХ ХХ',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                h20,
                ClassicLongButton(
                  onTap: () async {
                    if (_phoneController.text.isEmpty) {
                      showCustomSnackBar(
                          context, 'Введите номер', AnimatedSnackBarType.error);
                    } else if (_phoneController.text.length != 18) {
                      showCustomSnackBar(context, 'Некоректный номер',
                          AnimatedSnackBarType.error);
                    } else if (isAgree != true) {
                      showCustomSnackBar(
                          context,
                          'Вы не соглашены с условиями использование',
                          AnimatedSnackBarType.error);
                    } else {
                      context.mounted
                          ? showCustomSnackBar(
                              context, 'Отправка...', AnimatedSnackBarType.info)
                          : null;
                      LoginResult loginResult =
                          await loginController.sentVerifyCode(
                        _phoneController.text
                            .replaceAll('(', '')
                            .replaceAll(')', ''),
                      );

                      switch (loginResult) {
                        case LoginResult.error:
                          context.mounted
                              ? showCustomSnackBar(
                                  context,
                                  'Ошибка отправки кода',
                                  AnimatedSnackBarType.error)
                              : null;
                          break;
                        case LoginResult.success:
                          context.mounted
                              ? showCustomSnackBar(context, 'Код отправлен',
                                  AnimatedSnackBarType.success)
                              : null;
                          context.mounted
                              ? context.router.push(
                                  LoginCodeRoute(
                                      phoneNumber: _phoneController.text),
                                )
                              : null;
                          break;
                        case LoginResult.timeout:
                          context.mounted
                              ? showCustomSnackBar(
                                  context,
                                  'Время ожидания истекло',
                                  AnimatedSnackBarType.error)
                              : null;
                          break;
                        default:
                          context.mounted
                              ? showCustomSnackBar(
                                  context,
                                  'Код готов к отправке',
                                  AnimatedSnackBarType.info)
                              : null;
                      }
                    }
                  },
                  buttonText: 'Отправить код',
                ),
                h60,
                const Text(
                  "Я согласен(на) с условиями",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const Text(
                  "использования сервиса",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor),
                ),
                h20,
                Switch(
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                    activeTrackColor: const Color.fromARGB(255, 47, 73, 34),
                    activeColor: Colors.white,
                    value: isAgree,
                    onChanged: (value) {
                      setState(() {
                        isAgree = value;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
