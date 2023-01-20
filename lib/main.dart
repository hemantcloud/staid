import 'package:flutter/material.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/authenticate/login.dart';
import 'package:staid/views/dashboard.dart';
import 'package:staid/views/splash_only_image.dart';
import 'package:staid/views/splash_screen.dart';
import 'package:staid/views/test.dart';

void main() => runApp(const MyApp());
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Staid',
      theme: ThemeData(
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          color: AppColors.primaryDarkColor,
        ),
      ),
      home: const SplashScreen(),
      // home: Dashboard(bottomIndex: 1),
      // home: const Login(),
      // home: Test(),
    );
  }
}
