import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/account/change_phone_email.dart';
import 'package:staid/views/account/change_phone_verification.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
class ChangePhone extends StatefulWidget {
  ChangePhone({Key? key}) : super(key: key);

  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  TextEditingController phoneController = TextEditingController();
  late SharedPreferences prefs;
  late String auth_token;
  late String user_id;
  String CountryName = "";
  var CountryCodeController = new TextEditingController();
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryDarkColor,
        ),
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
                    'Change Mobile',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
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
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Country',
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
                        hintText: 'Enter New Phone Number',
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
            const SizedBox(height: 40.0),
            InkWell(
              onTap: () {
                String phone = phoneController.text;
                if(phone.isEmpty){
                  UtilityToaster().getToast("Please Enter Phone Number.");
                }else{
                  changePhone(context);
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
                  'Submit',
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
  // change phone number api
  Future<void> changePhone(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    request['country_code'] = CountryCodeController.text;
    request['mobile_number'] = phoneController.text;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.changePhoneUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X-AUTHTOKEN" : auth_token,
          "X-USERID" : user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    ChangePhoneModel responseChangePhone = await ChangePhoneModel.fromJson(jsonResponse);
    if(responseChangePhone.status == true){
      setState(() {});
      UtilityToaster().getToast(responseChangePhone.message);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => ChangePhoneVerification(phone: phoneController.text,country_code: CountryCodeController.text,))));
    }else{
      setState(() {});
      UtilityToaster().getToast(responseChangePhone.message);
    }
    return;
  }
}
