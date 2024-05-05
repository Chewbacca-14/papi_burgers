import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NotConnectedPage extends StatefulWidget {
  const NotConnectedPage({super.key});

  @override
  State<NotConnectedPage> createState() => _NotConnectedPageState();
}

class _NotConnectedPageState extends State<NotConnectedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              bool result = await InternetConnection().hasInternetAccess;
              result ? Navigator.pop(context) : null;
            },
            child: const Text('Try')),
      ),
    );
  }
}
