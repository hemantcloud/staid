import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/account/profile_model.dart';
import 'package:staid/models/chat/get_message_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MessageBox extends StatefulWidget {
  final sender_id;
  final task_id;
  MessageBox({Key? key,required this.task_id,required this.sender_id}) : super(key: key);

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  List<Messages>? getmessagelist= [];
  late String auth_token;
  late String user_id;
  UserData? user;
  var messageController = TextEditingController();
  // image picker code
  final ImagePicker imagePicker = ImagePicker();
  XFile? photoController;
  var bytes;
  // image picker code
  var scrollcontroller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all_process();
  }
  Future<void> all_process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profile(context);
    getmessageapi(context);
    auth_token = prefs.getString('auth_token').toString();
    user_id = prefs.getString('user_id').toString();
    print('my auth token is >>>>> {$auth_token}');
    print('my user id is >>>>> {$user_id}');
    setState(() {});
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
              const SizedBox(width: 15.0,),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Image.asset('assets/images/user_profile.png',width: 40.0,height: 40.0,),
                    ),
                    const SizedBox(width: 15.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Admin',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6.0,
                              height: 6.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xFF049D67),
                              ),
                            ),
                            const SizedBox(width: 6.0,),
                            const Text(
                              'Active Now',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        controller: scrollcontroller,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0,),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              // reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: getmessagelist!.length < 0 ? 1 : getmessagelist!.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  getmessagelist!.length < 0 ?
                  const Center(
                    child: Text('No Chat Yet !'),
                  ) :
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0,),
                    child:
                    getmessagelist![index].senderType == 'admin' ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/user_profile.png',width: 40.0,height: 40.0,),
                        const SizedBox(width: 10.0,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              color: const Color(0xFFF0F0F0),
                              /*border: Border.all(
                                width: 1.0,
                                color: AppColors.inputBorderColor,
                                style: BorderStyle.solid,
                              ),*/
                            ),
                            child: Text(
                              getmessagelist![index].message.toString(),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.blackChatColor,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              color: AppColors.primaryLightColor,
                            ),
                            child: Text(
                              getmessagelist![index].message.toString(),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0,),
                        Stack(
                          children: [
                            user == null || user!.profileImage!.isEmpty?
                            Image.asset(
                              'assets/images/chat_profile.png',
                              width: 40.0,height: 40.0,
                            ) :
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                              child: Image.network(
                                user!.profileImage.toString(),
                                // width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height,
                                width: 44.0,
                                height: 44.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
              },
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/user_profile.png',width: 40.0,height: 40.0,),
                const SizedBox(width: 10.0,),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: Color(0xFFF0F0F0),
                    ),
                    child: const Text(
                      'Hey i am Steve you have register on the app you have been assigned for the task',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.blackChatColor,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/user_profile.png',width: 40.0,height: 40.0,),
                const SizedBox(width: 10.0,),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: Color(0xFFF0F0F0),
                    ),
                    child: const Text(
                      'I will pay \$25 for this task and you have to complete the task within 8 hrs',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.blackChatColor,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: AppColors.primaryLightColor,
                    ),
                    child: const Text(
                      'Ok i am ready for the task',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0,),
                Image.asset('assets/images/chat_profile.png',width: 40.0,height: 40.0,),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/user_profile.png',width: 40.0,height: 40.0,),
                const SizedBox(width: 10.0,),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: Color(0xFFF0F0F0),
                    ),
                    child: const Text(
                      'Okay, then complete the task and let me know.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.blackChatColor,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),*/
            const SizedBox(height: 10.0),
          ],
        ),
      ),
      /*bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 51.0,
          padding: const EdgeInsets.symmetric(horizontal: 10.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Color(0xFFF0F0F0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  pickimagefromcamera(context, ImageSource.camera);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                  child: SvgPicture.asset('assets/icons/camera.svg',width: 24.0,height: 24.0,),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Poppins',
                    color: AppColors.lightTextColor,
                  ),
                  cursorColor: AppColors.lightTextColor,
                  decoration: const InputDecoration(
                    hintText: 'Type Message...',
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
                padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                child: SvgPicture.asset('assets/icons/attach.svg',),
              ),
              InkWell(
                onTap: (){
                  var camera_image = photoController!.path;
                  var message = messageController.text;
                  if(camera_image.isEmpty && message.isEmpty){
                    UtilityToaster().getToast('Please Enter something...');
                  }else{
                    sendmessageapi(context);
                  // }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                  child: SvgPicture.asset('assets/icons/send.svg',),
                ),
              ),
            ],
          ),
        ),
      ),*/
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 51.0,
          padding: const EdgeInsets.symmetric(horizontal: 10.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Color(0xFFF0F0F0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  pickimagefromcamera(context, ImageSource.camera);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                  child: SvgPicture.asset('assets/icons/camera.svg',width: 24.0,height: 24.0,),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Poppins',
                    color: AppColors.lightTextColor,
                  ),
                  cursorColor: AppColors.lightTextColor,
                  decoration: const InputDecoration(
                    hintText: 'Type Message...',
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
                padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                child: SvgPicture.asset('assets/icons/attach.svg',),
              ),
              InkWell(
                onTap: (){
                  messageController.text.isEmpty ?
                  UtilityToaster().getToast('Please Enter Message..') :
                  sendmessageapi(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0,),
                  child: SvgPicture.asset('assets/icons/send.svg',),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // profile api
  Future<void> profile(BuildContext context) async {
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
  // get message api
  Future<void> getmessageapi(BuildContext context) async {
    getmessagelist!.clear();
    Loader.ProgressloadingDialog(context, true);
    var request = {};
    request['taskid'] = widget.task_id;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.getmessageUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X-AUTHTOKEN" : auth_token,
          "X-USERID" : user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    GetMessageModel responsegetmessage = await GetMessageModel.fromJson(jsonResponse);
    if(responsegetmessage.status == true){
      getmessagelist  = responsegetmessage.data!.messages;
      setState(() {});
    }else{
      UtilityToaster().getToast(responsegetmessage.message);
      setState(() {});
    }
    return;
  }
  // send message api
  sendmessageapi(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.sendmessageUrl),
      );
      Map<String, String> header = {
        "content-type": "application/json",
        "accept": "application/json",
        "X-AUTHTOKEN" : auth_token,
        "X-USERID" : user_id,
      };
      request.headers.addAll(header);
      if (photoController == null || photoController == "") {
        request.fields['message'] =  messageController.text;
      }else {
        request.files.add(await http.MultipartFile.fromPath('profileImage', photoController!.path));
      }
      request.fields['taskid'] =  widget.task_id;
      request.fields['sender_id'] =  widget.sender_id;
      var response = await request.send();
      Loader.ProgressloadingDialog(context, false);

      print("response is----------${response.headers.toString()}");
      response.stream.transform(convert.utf8.decoder).listen((event) {
        Map map = convert.jsonDecode(event);

        if (map["status"] == true) {
          UtilityToaster().getToast('Message sent successfully');
          getmessageapi(context);
          messageController = TextEditingController(text: '');
          setState(() {});
          /// SUCCESS
        } else {
          UtilityToaster().getToast('Message Not sent !');
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
  ///Image picker...............
  Future pickimagefromcamera(BuildContext context,imageSource) async {
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
