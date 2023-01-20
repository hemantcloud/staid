import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/account/change_email_address_verification_model.dart';
import 'package:staid/models/authenticate/email_submit_model.dart';
import 'package:staid/models/authenticate/email_verify_model.dart';
import 'package:staid/views/account/profile.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/authenticate/submit_phone_verification.dart';
// import 'package:otp_text_field/otp_text_field.dart';
// import 'package:otp_text_field/style.dart';
// import 'package:staid/views/authenticate/change_phone_verification.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;
import 'package:pin_code_fields/pin_code_fields.dart';

class SubmitEmailVerification extends StatefulWidget {
  String name;
  String email;
  String country_code;
  String phone;
  String password;
  SubmitEmailVerification({Key? key,required this.name,required this.email,required this.country_code,required this.phone,required this.password,}) : super(key: key);

  @override
  State<SubmitEmailVerification> createState() => _SubmitEmailVerificationState();
}

class _SubmitEmailVerificationState extends State<SubmitEmailVerification> {
  // OtpFieldController otpController = OtpFieldController();
  TextEditingController emailVerificationController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  late SharedPreferences prefs;
  late String auth_token;
  late String user_id;
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
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SvgPicture.asset(
              'assets/icons/left.svg',
              width: 10.0,
              height: 10.0,
            ),
          ),
        ),
        backgroundColor: AppColors.primaryLightColor,
        centerTitle: true,
        title: const Text(
          'Verification',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.0,
            // fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.009,),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/verification.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
              const SizedBox(height: 20.0,),
              const Text(
                'Enter verification code we have sent to your registered email address',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0,),
              /*OTPTextField(
                  controller: otpController,
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldWidth: 45,
                  fieldStyle: FieldStyle.underline,
                  obscureText: false,
                  // outlineBorderRadius: 15,
                  style:  const TextStyle(
                    fontFamily: 'Poppins',
                  ),
                  // onChanged: (pin) {
                  //   print("Changed: " + pin);
                  // },
                  // onCompleted: (pin) {
                  //   print("Completed: " + pin);
                  // }
              ),*/
              // pincode
              PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Color(0xff254d71),
                  fontWeight: FontWeight.bold,
                ),
                length: 4,
                obscureText: false,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {},
                backgroundColor: Colors.transparent,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 47,
                  activeFillColor: Colors.transparent,
                  inactiveColor: Color(0xFFB7B7B7),
                  inactiveFillColor: Colors.red,
                ),
                cursorColor: AppColors.blackLightColor,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: false,
                errorAnimationController: errorController,
                controller: emailVerificationController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  // BoxShadow(
                  //   offset: Offset(0, 1),
                  //   color: Colors.white,
                  //   blurRadius: 1,
                  // )
                ],
                // onCompleted: (v) {
                //   debugPrint("Completed");
                // },
                onChanged: (value) {
                  // debugPrint(value);
                  // setState(() {
                  //   var currentText = value;
                  // });
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  return true;
                },
              ),
              // pincode
              const SizedBox(height: 20.0,),
              InkWell(
                onTap: (){
                  // otpController.clear();
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: const Text(
                  'Resend',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            // openModal();
            // emailVerification(context);
            emailVerification(context);
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
              'Verify',
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
      ),
    );
  }
  Future openModal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 50.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Colors.white),
            color: Colors.white,
          ),
          height: 350.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/verification_successfully.png',width: 77.0,height: 77.0),
              const Text(
                'Your Email Address Has been Verified',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => SubmitPhoneVerification(name: widget.name,email: widget.email,country_code: widget.country_code,phone: widget.phone,password: widget.password,email_otp: emailVerificationController.text,))));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  //height: MediaQuery.of(context).size.height * 0.06,
                  height: 50.0,
                  // width: 343.0,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDarkColor,
                    borderRadius: BorderRadius.circular(43.0),
                  ),
                  child: const Text(
                    'Done',
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
            ],
          ),
        ),
      ),
    );
  }
  // email verification for register api
  Future<void> emailVerification(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    var request = {};
    request['email'] = widget.email;
    request['otp'] = emailVerificationController.text;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.submitEmailVerificationUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X_CLIENT" : Urls.x_client_token,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    EmailVerificationModel responseSubmitEmailVerification = await EmailVerificationModel.fromJson(jsonResponse);
    if(responseSubmitEmailVerification.status == true){
      UtilityToaster().getToast(responseSubmitEmailVerification.message);
      setState(() {});
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => Profile())));
      openModal();
    }else{
      UtilityToaster().getToast(responseSubmitEmailVerification.message);
      setState(() {});
    }
    return;
  }
}
