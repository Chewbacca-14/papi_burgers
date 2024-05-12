import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/providers/internet_status_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class NotConnectedPage extends StatefulWidget {
  const NotConnectedPage({super.key});

  @override
  State<NotConnectedPage> createState() => _NotConnectedPageState();
}

class _NotConnectedPageState extends State<NotConnectedPage> {
  bool isLoading = false;

  bool isFirstRetry = true;

  void startLoading() {
    setState(() {
      isLoading = true;
      isFirstRetry = false;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    InternetStatusProvider internetStatusProvider =
        Provider.of<InternetStatusProvider>(context, listen: true);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 100, color: Colors.red),
              !isLoading
                  ? Text(
                      isFirstRetry
                          ? 'Кажется пропало интернет подключение'
                          : 'Проверьте подключение к интернету и попробуйте снова',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ))
                  : const SizedBox(),
              h30,
              !isLoading
                  ? ClassicLongButton(
                      onTap: () async {
                        startLoading();

                        bool result =
                            await InternetConnection().hasInternetAccess;
                        if (result) {
                          internetStatusProvider
                              .updateStatus(InternetStatus.connected);
                        }
                      },
                      buttonText: 'Проверить подключение к интернету')
                  : const CircularProgressIndicator(
                      color: Colors.red,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
