import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/authenticate/login.dart';

class SplashScreenOnlyImage extends StatefulWidget {
  const SplashScreenOnlyImage({Key? key}) : super(key: key);

  @override
  State<SplashScreenOnlyImage> createState() => _SplashScreenOnlyImageState();
}

class _SplashScreenOnlyImageState extends State<SplashScreenOnlyImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2),() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const Login())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/splash_only_image.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
