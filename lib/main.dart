import 'package:flutter/material.dart';
import 'package:pawrapet/initialize.dart';
import 'package:pawrapet/providers/authProvider.dart';
import 'package:pawrapet/providers/otpProvider.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => OtpProvider()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pawrapets',
      theme: lightTheme,
      home: const Initialize(),
    );
  }
}
