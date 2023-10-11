import 'package:flutter/material.dart';
import 'package:pawrapet/initialize.dart';
import 'package:pawrapet/utils/constants.dart';

void main() {
  runApp(const MainApp(
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pawrapets',
      theme: lightTheme,
      home: const Initialize()
    );
  }
}
