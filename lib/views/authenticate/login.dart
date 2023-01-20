import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:staid/models/authenticate/login_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/authenticate/register.dart';
import 'package:staid/views/dashboard.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
// apis
import 'dart:convert' as convert;
import 'dart:async';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:staid/views/utilities/urls.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// apis

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailAddressController = TextEditingController();
  var passwordController = TextEditingController();
  bool _isHidden = false;
  String devicetype = '';
  String deviceid = '';
  String text = "Loading...";
  SharedPreferences? pre;
  @override
  void initState() {
    super.initState();
    loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: 136.0,
                  height: 141.0,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.boxShadowColor,
                    offset: Offset(
                      0.0,
                      -4.0,
                    ),
                    blurRadius: 80.0,
                    spreadRadius: 0,
                  ),
                ],
                // border: Border(left: BorderSide(color: Colors.red,style: BorderStyle.solid,width: 1.0,),),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 57.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.inputBorderColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                        // color: Colors.green,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: SvgPicture.asset('assets/icons/message.svg'),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: SvgPicture.asset(
                              'assets/icons/divider_line.svg',
                              color: Colors.black,
                              width: 2.0,
                              height: 30.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              // textAlignVertical: TextAlignVertical.bottom,
                              controller: emailAddressController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 14.0,
                                // fontFamily: 'Poppins',
                                color: AppColors.lightTextColor,
                              ),
                              cursorColor: AppColors.lightTextColor,
                              decoration: const InputDecoration(
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  color: AppColors.lightTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please Enter Password';
                              //   }else {
                              //     if(!value.contains('@')){
                              //       return 'Enter a Valid Email';
                              //     }else{
                              //       return null;
                              //     }
                              //   }
                              // },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 57.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.inputBorderColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                        // color: Colors.green,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child:
                                SvgPicture.asset('assets/icons/password.svg'),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: SvgPicture.asset(
                              'assets/icons/divider_line.svg',
                              color: Colors.black,
                              width: 2.0,
                              height: 30.0,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _isHidden == false ? true : false,
                              // textAlignVertical: TextAlignVertical.bottom,
                              // keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                color: AppColors.lightTextColor,
                              ),
                              cursorColor: AppColors.lightTextColor,
                              decoration: const InputDecoration(
                                hintText: '•••••••••••',
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  color: AppColors.lightTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please Enter Password';
                              //   }else{
                              //     if(value.length < 6){
                              //       return 'Please Enter Atleast 6 Digit';
                              //     }else{
                              //       return null;
                              //     }
                              //   }
                              // },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.01),
                            child: InkWell(
                              onTap: () {
                                _isHidden = !_isHidden;
                                setState(() {});
                              },
                              child: _isHidden == false
                                  ? SvgPicture.asset(
                                      'assets/icons/password_hide.svg',
                                      color: AppColors.lightTextColor,
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/password_show.svg',
                                      color: AppColors.lightTextColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        //informaion about device
                        print('device id is ${deviceid}');
                        print('device type is ${devicetype}');
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.primaryDarkColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(context,MaterialPageRoute(builder: ((context) => const Profile())));
                        String email = emailAddressController.text;
                        String password = passwordController.text;
                        // if(email.isEmpty || password.isEmpty){
                        //   UtilityToaster().getToast("Please enter mobile number and password.");
                        // }
                        if (email.isEmpty && password.isEmpty) {
                          UtilityToaster().getToast(
                              "Please Enter Email Address and Password.");
                          // UtilityToaster().getToast("Please Enter Email Address.");
                        } else if (email.isEmpty) {
                          UtilityToaster()
                              .getToast("Please Enter Email Address.");
                        } else if (!email.contains('@gmail.com')) {
                          UtilityToaster()
                              .getToast("Please Enter Valid Email Address.");
                        } else if (password.isEmpty) {
                          UtilityToaster().getToast("Please Enter Password.");
                        } else {
                          // print('login validation completed.');
                          loginapi(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        // width: MediaQuery.of(context).size.width * 100.0,
                        //height: MediaQuery.of(context).size.height * 0.06,
                        height: 57.0,
                        // width: 343.0,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDarkColor,
                          borderRadius: BorderRadius.circular(43.0),
                        ),
                        child: const Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don’t have an account? ',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: AppColors.secondaryLightColor,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => const Register())));
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginapi(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    request['email'] = emailAddressController.text;
    request['password'] = passwordController.text;
    request['device_type'] = devicetype;
    request['device_id'] = deviceid;
    request['fcm_token'] = 'static_token';
    request['timezone'] = 'Asia/Kolkata';
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.loginUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X_CLIENT": Urls.x_client_token,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    LoginModel responseLogin = await LoginModel.fromJson(jsonResponse);
    if (responseLogin.status == true) {
      UtilityToaster().getToast(responseLogin.message);
      prefs.setString(
          'auth_token', responseLogin.data!.userData!.authToken.toString());
      prefs.setString('user_id', responseLogin.data!.userData!.id.toString());
      prefs.setBool('isLogin', true);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => Dashboard(bottomIndex: 0))));
    } else {
      if (responseLogin.message == null ||
          responseLogin.message == 'null' ||
          responseLogin.message == '') {
        UtilityToaster().getToast('Invalid password please try again.');
      } else {
        UtilityToaster().getToast(responseLogin.message.toString());
      }
    }
    return;
  }

  /// loads device info
  void loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      // e.g. "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
      print('Web - Running on ${webBrowserInfo.userAgent}');
      setState(() {
        text = webBrowserInfo.toMap().toString();
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('iOS - Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      deviceid = iosInfo.model.toString();
      devicetype = 'ios';
      setState(() {
        text = iosInfo.toMap().toString();
      });
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Android - Running on ${androidInfo.id}'); // e.g. "Moto G (4)"
      deviceid = androidInfo.id;
      devicetype = 'android';
      setState(() {
        text = androidInfo.toMap().toString();
      });
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      print(windowsInfo.toMap().toString());
      setState(() {
        text = windowsInfo.toMap().toString();
      });
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOSInfo = await deviceInfo.macOsInfo;
      print(macOSInfo.toMap().toString());
      setState(() {
        text = macOSInfo.toMap().toString();
      });
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      print(linuxInfo.toMap().toString());
      setState(() {
        text = linuxInfo.toMap().toString();
      });
    }
  }
}
