import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/account/profile_model.dart';
import 'package:staid/models/authenticate/logout_model.dart';
import 'package:staid/views/account/change_password.dart';
import 'package:staid/views/account/profile.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/authenticate/login.dart';
import 'package:staid/views/dashboard.dart';
import 'package:staid/views/task/task.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'dart:convert' as convert;

import 'package:staid/views/utilities/urls.dart';
class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late SharedPreferences prefs;
  late String auth_token;
  late String user_id;
  UserData? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all_process();
  }
  Future<void> all_process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profile(context);
      auth_token = prefs.getString('auth_token')!;
      user_id = prefs.getString('user_id')!;
      print('my auth token is >>>>> {$auth_token}');
      print('my user id is >>>>> {$user_id}');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryLightColor,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 40.0,bottom: 10.0,left: 20.0,right: 20.0,),
          child: Row(
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0,),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: Stack(
                      children: [
                        user == null || user!.profileImage!.isEmpty?
                        Image.asset(
                          'assets/images/chat_profile.png',
                        ) :
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: Image.network(
                            user!.profileImage.toString(),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    user == null ? '' : user!.name.toString(),
                    style: TextStyle(
                      fontFamily: 'poppins',
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: ((context) => const Profile())));
              },
              child: Container(
                height: 57.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0,),
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
                      child: SvgPicture.asset('assets/icons/user.svg'),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SvgPicture.asset(
                        'assets/icons/divider_line.svg',
                        color: Colors.black,
                        width: 2.0,
                        height: 30.0,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                      child: SvgPicture.asset('assets/icons/right.svg'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: ((context) => const ChangePassword())));
              },
              child: Container(
                height: 57.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0,),
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
                      child: SvgPicture.asset('assets/icons/password.svg'),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SvgPicture.asset(
                        'assets/icons/divider_line.svg',
                        color: Colors.black,
                        width: 2.0,
                        height: 30.0,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                      child: SvgPicture.asset('assets/icons/right.svg'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            InkWell(
              onTap: (){
                logout(context);
              },
              child: Container(
                height: 57.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0,),
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
                      child: SvgPicture.asset('assets/icons/logout.svg'),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SvgPicture.asset(
                        'assets/icons/divider_line.svg',
                        color: Colors.black,
                        width: 2.0,
                        height: 30.0,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
  // register api
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Loader.ProgressloadingDialog(context, true);
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.logoutUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X_CLIENT" : Urls.x_client_token,
          "X-AUTHTOKEN" : auth_token,
          "X-USERID" : user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    LogoutModel responselogout = await LogoutModel.fromJson(jsonResponse);
    if(responselogout.status == true){
      prefs.setString('auth_token','');
      prefs.setString('user_id','');
      prefs.setBool('isLogin',false);
      // Navigator.push(context, MaterialPageRoute(builder: ((context) => Dashboard(bottomIndex: 0,))));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => const Login())));
      UtilityToaster().getToast(responselogout.message);
      setState(() {});
    }else{
      UtilityToaster().getToast(responselogout.message);
      setState(() {});
    }
    return;
  }
  // profile api
  Future<void> profile(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.profileUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X-AUTHTOKEN" : auth_token,
          "X-USERID" : user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    ProfileModel responseprofile = await ProfileModel.fromJson(jsonResponse);
    if(responseprofile.status == true){
      user = responseprofile.data!.userData!;
      // print('success contactSubmit');
      // UtilityToaster().getToast(responseprofile.message);
      setState(() {});
    }else{
      UtilityToaster().getToast(responseprofile.message);
      setState(() {});
      // print('failed contactSubmit');
    }
    return;
  }
}
