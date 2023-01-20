import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/account/profile_model.dart';
import 'package:staid/models/account/update_profile_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/dashboard.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class EditProfile extends StatefulWidget {
  UserData userModel;
  EditProfile({Key? key,required this.userModel}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // final ImagePicker _picker = ImagePicker();
  // image picker
  final ImagePicker imagePicker = ImagePicker();
  XFile? photoController;
  String img = "";
  var bytes;
  // image picker
  late SharedPreferences prefs;
  late String auth_token;
  late String user_id;
  UserData? user;
  var userNameFromModel;
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
      setData();
      auth_token = prefs.getString('auth_token')!;
      user_id = prefs.getString('user_id')!;
      print('my auth token is >>>>> {$auth_token}');
      print('my user id is >>>>> {$user_id}');
    });
  }

  ///Set data controller...............
  setData(){
    nameController.text = widget.userModel.name!.isNotEmpty ? widget.userModel.name.toString() : '';
    emailController.text = widget.userModel.email!.isNotEmpty ? widget.userModel.email.toString() : '';
    phoneController.text = widget.userModel.mobileNumber!.isNotEmpty ? widget.userModel.mobileNumber.toString() : '';
    userNameFromModel = widget.userModel.name!.isNotEmpty ? widget.userModel.name.toString() : '';
    setState(() {});
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
                  /*Stack(
                    children: [
                      Container(
                      alignment: Alignment.center,
                      width: 118.0,
                      height: 118.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: AssetImage('assets/images/chat_profile.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        border: Border.all(
                          color: Color(0xFF284AB5),
                          width: 1.5,
                        ),
                      ),
                    ),
                      Positioned(
                        bottom: 20.0,
                        right: 20.0,
                        child: SvgPicture.asset(
                            'assets/icons/camera.svg',
                            color: Colors.white,
                          ),
                      ),
                    ],
                  ), */
                  CircleAvatar(
                    radius: 60,
                    child: Stack(
                      children: [
                        photoController != null ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: Image.file(
                            File(photoController!.path),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                          ),
                        ) :
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
                        Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                bottoms_Profileimage(context);
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                AppColors.primaryLightColor,
                                child: SvgPicture.asset(
                                  'assets/icons/camera.svg',
                                  height: 20.0,
                                  width: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    // user == null ? '' : user!.name.toString(),
                    // user == null ? '' : userNameFromModel,
                    widget.userModel.name!.isNotEmpty ? widget.userModel.name.toString() : '',
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
                      controller: nameController,
                      // textAlignVertical: TextAlignVertical.bottom,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                        color: AppColors.lightTextColor,
                      ),
                      cursorColor: AppColors.lightTextColor,
                      decoration: const InputDecoration(
                        hintText: 'Full name',
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
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                        color: AppColors.lightTextColor,
                      ),
                      cursorColor: AppColors.lightTextColor,
                      enabled: false,
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
                    child: SvgPicture.asset('assets/icons/phone.svg'),
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
                      controller: phoneController,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                        color: AppColors.lightTextColor,
                      ),
                      cursorColor: AppColors.lightTextColor,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
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
            const SizedBox(height: 40.0),
            InkWell(
              onTap: () {
                UserUpdateprofileRequest(context);
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
      setState(() {});
    }else{
      UtilityToaster().getToast(responseprofile.message);
      setState(() {});
    }
    return;
  }
  // update profile api
  UserUpdateprofileRequest(BuildContext context) async {
     Loader.ProgressloadingDialog(context, true);
    SharedPreferences pr = await SharedPreferences.getInstance();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.updateProfileUrl),
      );
      Map<String, String> header = {
        "content-type": "application/json",
        "accept": "application/json",
        "X-AUTHTOKEN" : auth_token,
        "X-USERID" : user_id,
      };
      request.headers.addAll(header);
      if (photoController == null || photoController == "" ) {
      }else {
        request.files.add(await http.MultipartFile.fromPath('profileImage', photoController!.path));
      }
      request.fields['name'] =  nameController.text;
      var response = await request.send();
      Loader.ProgressloadingDialog(context, false);

      print("response is----------${response.headers.toString()}");
      response.stream.transform(convert.utf8.decoder).listen((event) {
        Map map = convert.jsonDecode(event);

        if (map["status"] == true) {
          UtilityToaster().getToast('Updated successfully');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Dashboard(bottomIndex: 3,)));
          /// SUCCESS
        } else {
          UtilityToaster().getToast('Not Updated successfully');
          /// FAIL
        }
      });
    } catch (e) {
      ///EXCEPTION
      Loader.ProgressloadingDialog(context, false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error: $e')),
      );
    }
  }
  // profile image picker
  /// Image pick Bottom dialog.............
  bottoms_Profileimage(BuildContext context){
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                //Navigator.pop(context);
                pickImage(context,ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Gallery'),
              onTap: () {
                // Navigator.pop(context);
                pickImage(context,ImageSource.gallery);
              },
            ),
          ]);
        });
  }
  ///Image picker...............
  Future pickImage(BuildContext context,imageSource) async {
    if(!kIsWeb){
      var image = await imagePicker.pickImage(
          source: imageSource,
          imageQuality: 10,
      );
      if (image == null) {
        print('+++++++++null');
        Navigator.pop(context);
      } else {
        photoController = XFile(image.path);
        Navigator.pop(context);
        setState((){});
      }
    }else if(kIsWeb){
      var image = await imagePicker.pickImage(source: imageSource,
          imageQuality: 10);
      if (image == null) {
        print('+++++++++null');
        Navigator.pop(context);
      } else {
        photoController = XFile(image.path);
      }
      setState((){});
      print('image path is ${bytes}');
      }
    }
  }
