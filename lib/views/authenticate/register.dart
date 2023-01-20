import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:staid/views/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/authenticate/submit_email_verification.dart';
import 'package:staid/views/utilities/toast.dart';

import 'package:staid/models/authenticate/email_submit_model.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;
import 'package:country_picker/country_picker.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  bool _isHidden = false;
  String CountryName = "";
  var CountryCodeController = new TextEditingController();
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.32,
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
              height: MediaQuery.of(context).size.height * 0.68,
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
                  color: Colors.white),
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
                            child: TextFormField(
                              // textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.text,
                              controller: nameController,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                color: AppColors.lightTextColor,
                              ),
                              cursorColor: AppColors.lightTextColor,
                              decoration: const InputDecoration(
                                hintText: 'Name',
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0,),
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
                            child: SvgPicture.asset('assets/icons/message.svg'),
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
                              // textAlignVertical: TextAlignVertical.bottom,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0,),
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
                          InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                exclude: <String>['KN', 'MF'],
                                //Optional. Shows phone code before the country name.
                                showPhoneCode: true,
                                favorite: ['+91','IN'],
                                onSelect: (Country country) {
                                  print('Select country: ${country.phoneCode}');
                                  CountryCodeController.text = '+'+country.phoneCode;
                                  setState(() {});
                                },
                              );
                            },
                            child: Container(
                              width: 60.0,
                              height: 30.0,
                              alignment: Alignment.center,
                              child: TextField(
                                controller: CountryCodeController,
                                enabled: false,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  color: AppColors.lightTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Select',
                                  fillColor: AppColors.lightTextColor,
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                // Only numbers can be entered
                              ),
                            ),
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
                              controller: phoneController,
                              // textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                color: AppColors.lightTextColor,
                              ),
                              cursorColor: AppColors.lightTextColor,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  color: AppColors.lightTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                counterText: "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0,),
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
                              controller: passwordController,
                              obscureText: _isHidden == false ? true : false,
                              // textAlignVertical: TextAlignVertical.bottom,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                color: AppColors.lightTextColor,
                              ),
                              cursorColor: AppColors.lightTextColor,
                              decoration: const InputDecoration(
                                hintText: 'Password',
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
                    const SizedBox(height: 10.0,),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.primaryDarkColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    InkWell(
                      onTap: () {
                        String name = nameController.text;
                        String email = emailController.text;
                        String phone = phoneController.text;
                        String password = passwordController.text;
                        String country_code = CountryCodeController.text;
                        if(name.isEmpty && email.isEmpty && phone.isEmpty && password.isEmpty){
                          UtilityToaster().getToast("Please Fill all Fields to Register.");
                        }else if(name.isEmpty){
                          UtilityToaster().getToast("Please Enter Name.");
                        }else if(email.isEmpty){
                          UtilityToaster().getToast("Please Enter Email Address.");
                        }else if(!email.contains('@gmail.com')){
                          UtilityToaster().getToast("Please Enter Valid Email Address.");
                        }else if(country_code.isEmpty){
                          UtilityToaster().getToast("Please Select Country Code.");
                        }else if(phone.isEmpty){
                          UtilityToaster().getToast("Please Enter Phone Number.");
                        }else if(phone.length < 10 || phone.length > 10){
                          UtilityToaster().getToast("Please Enter Valid Phone Number.");
                        }else if(password.isEmpty) {
                          UtilityToaster().getToast("Please Enter Password.");
                        }else if(password.length < 6) {
                          UtilityToaster().getToast("Password should be greater than 6 char.");
                        }else if(!regex.hasMatch(password)) {
                          UtilityToaster().getToast("Enter strong password.");
                        }else{
                          // print('register validation completed.');
                          // UtilityToaster().getToast(".");
                          emailSubmit(context);

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
                          'Register',
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
                    const SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: AppColors.secondaryLightColor,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login',
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

  Future<void> emailSubmit(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    var request = {};
    request['email'] = emailController.text;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.emailSubmitUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X_CLIENT" : Urls.x_client_token,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    EmailSubmitModel responseEmailSubmit = await EmailSubmitModel.fromJson(jsonResponse);
    if(responseEmailSubmit.status == true){
      UtilityToaster().getToast(responseEmailSubmit.message);
      setState(() {});
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => SubmitEmailVerification(name: nameController.text,email: emailController.text,country_code: CountryCodeController.text,phone: phoneController.text,password: passwordController.text,))));
    }else{
      UtilityToaster().getToast(responseEmailSubmit.message);
      setState(() {});
    }
    return;
  }
}
