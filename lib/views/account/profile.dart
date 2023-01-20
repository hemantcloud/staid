import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/account/profile_model.dart';
import 'package:staid/views/account/change_phone.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/account/change_email.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;

import 'edit_profile.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset('assets/icons/left.svg'),
              ),
              const Expanded(
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
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: ((context) =>  EditProfile(userModel: user!,))));
                },
                child: SvgPicture.asset(
                  'assets/icons/pencil.svg',
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
                  /*Container(
                    alignment: Alignment.center,
                    width: 118.0,
                    height: 118.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image:
                          AssetImage("assets/images/chat_profile.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      border: Border.all(
                        color: Color(0xFF284AB5),
                        width: 1.5,
                      ),
                    ),
                  ),*/
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
                    style: const TextStyle(
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
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: AppColors.inputBorderColor,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      color: AppColors.lightTextColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    user == null ? '' : user!.name.toString(),
                    style: const TextStyle(
                      fontFamily: 'poppins',
                      color: AppColors.blackDarkColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: AppColors.inputBorderColor,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      color: AppColors.lightTextColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user == null ? '' : user!.email.toString(),
                          style: const TextStyle(
                            fontFamily: 'poppins',
                            color: AppColors.blackDarkColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: ((context) =>  ChangeEmail())));
                        },
                        child: SvgPicture.asset(
                          'assets/icons/pencil.svg',
                          color: AppColors.primaryLightColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    width: 1.0,
                    color: AppColors.inputBorderColor,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      color: AppColors.lightTextColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user == null ? '' : user!.countryCode.toString() + ' ' + user!.mobileNumber.toString(),
                          style: const TextStyle(
                            fontFamily: 'poppins',
                            color: AppColors.blackDarkColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: ((context) =>  ChangePhone())));
                        },
                        child: SvgPicture.asset(
                          'assets/icons/pencil.svg',
                          color: AppColors.primaryLightColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
  // profile api
  Future<void> profile(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Loader.ProgressloadingDialog(context, true);
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
      setState(() {});
    }else{
      UtilityToaster().getToast(responseprofile.message);
      setState(() {});
    }
    return;
  }
}
