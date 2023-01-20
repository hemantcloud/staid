import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/views/authenticate/login.dart';
import 'package:staid/views/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs;
   String auth_token = '';
   String user_id = '';
   bool isLogin = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all_process();
  }
  Future<void> all_process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getBool('isLogin') == true){
        Timer(const Duration(seconds: 2),() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Dashboard(bottomIndex: 0))));
      }else{
        Timer(const Duration(seconds: 2),() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const Login())));
      }
    });
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
              'assets/images/bg.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/logo.svg',
            // width: 177.0,
            // height: 183.0,
          ),
        ),
      ),
    );
  }
}
