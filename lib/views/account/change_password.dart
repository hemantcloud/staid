import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/account/change_password_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/dashboard.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'dart:convert' as convert;

import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isHidden = false;
  bool _isHiddenOld = false;
  bool _isHiddenNew = false;
  late SharedPreferences prefs;
  late String auth_token;
  late String user_id;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all_process();
  }
  Future<void> all_process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
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
                    'New Password',
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
                  Image.asset('assets/images/change_password.png',width: 208.0,height: 208.0,),
                  const SizedBox(height: 20.0,),
                  Text(
                    'Reset your password to login back to your account',
                    textAlign: TextAlign.center,
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
            Container(
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
                    child: TextFormField(
                      obscureText: _isHiddenOld == false ? true : false,
                      controller: oldPasswordController,
                      // textAlignVertical: TextAlignVertical.bottom,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                        color: AppColors.lightTextColor,
                      ),
                      cursorColor: AppColors.lightTextColor,
                      decoration: const InputDecoration(
                        hintText: 'Old Password',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                    child: InkWell(
                      onTap: (){
                        _isHiddenOld = !_isHiddenOld;
                        setState(() {});
                      },
                      child: _isHiddenOld == false ?
                      SvgPicture.asset('assets/icons/password_hide.svg',color: AppColors.lightTextColor,) :
                      SvgPicture.asset('assets/icons/password_show.svg',color: AppColors.lightTextColor,),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
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
                    child: TextFormField(
                      obscureText: _isHidden == false ? true : false,
                      // textAlignVertical: TextAlignVertical.bottom,
                      controller: newPasswordController,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                        color: AppColors.lightTextColor,
                      ),
                      cursorColor: AppColors.lightTextColor,
                      decoration: const InputDecoration(
                        hintText: 'New Password',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                    child: InkWell(
                      onTap: (){
                        _isHidden = !_isHidden;
                        setState(() {});
                      },
                      child: _isHidden == false ?
                      SvgPicture.asset('assets/icons/password_hide.svg',color: AppColors.lightTextColor,) :
                      SvgPicture.asset('assets/icons/password_show.svg',color: AppColors.lightTextColor,),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
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
                    child: TextFormField(
                      obscureText: _isHiddenNew == false ? true : false,
                      // textAlignVertical: TextAlignVertical.bottom,
                      controller: confirmPasswordController,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                        color: AppColors.lightTextColor,
                      ),
                      cursorColor: AppColors.lightTextColor,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                    child: InkWell(
                      onTap: (){
                        _isHiddenNew = !_isHiddenNew;
                        setState(() {});
                      },
                      child: _isHiddenNew == false ?
                      SvgPicture.asset('assets/icons/password_hide.svg',color: AppColors.lightTextColor,) :
                      SvgPicture.asset('assets/icons/password_show.svg',color: AppColors.lightTextColor,),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            InkWell(
              onTap: () {
                var oldpassword = oldPasswordController.text;
                var newpassword = newPasswordController.text;
                var confirmpassword = confirmPasswordController.text;
                if(oldpassword.isEmpty){
                  UtilityToaster().getToast("Please Enter Old Password.");
                } else if(newpassword.isEmpty){
                  UtilityToaster().getToast("Please Enter New Password.");
                } else if(confirmpassword.isEmpty){
                  UtilityToaster().getToast("Please Enter Confirm Password.");
                }else if(!regex.hasMatch(newpassword)) {
                  UtilityToaster().getToast("Enter strong password.");
                }else if(!regex.hasMatch(confirmpassword)) {
                  UtilityToaster().getToast("Enter strong password.");
                }else if(newpassword != confirmpassword) {
                  UtilityToaster().getToast("Enter new password and confirm password same.");
                }else{
                  changePassword(context);
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
                  'Update',
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
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
  // change password api
  Future<void> changePassword(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    request['old_password'] = oldPasswordController.text;
    request['new_password'] = newPasswordController.text;
    request['confirm_password'] = confirmPasswordController.text;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.changePasswordUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X-AUTHTOKEN" : auth_token,
          "X-USERID" : user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    ChangePasswordModel responseChangePassword = await ChangePasswordModel.fromJson(jsonResponse);
    if(responseChangePassword.status == true){
      setState(() {});
      UtilityToaster().getToast(responseChangePassword.message);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => Dashboard(bottomIndex: 3,))));
    }else{
      setState(() {});
      UtilityToaster().getToast(responseChangePassword.message);
    }
    return;
  }
}
