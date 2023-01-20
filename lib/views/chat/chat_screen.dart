// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/account/profile_model.dart';
import 'package:staid/models/chat/get_message_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/chat/audio_player_screen.dart';
import 'package:staid/views/chat/image_viewer.dart';
import 'package:staid/views/chat/pdf_view.dart';
import 'package:staid/views/video_viewer.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:staid/views/utilities/utility.dart';
import 'package:file_picker/file_picker.dart';

class ChatScreen extends StatefulWidget {
  final sender_id;
  String task_id;
  ChatScreen({Key? key, required this.task_id, required this.sender_id})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Messages>? getmessagelist = [];
  late String auth_token;
  late String user_id;
  UserData? user;
  var messageController = TextEditingController();
  // image picker code
  final ImagePicker imagePicker = ImagePicker();
  XFile? photoController;
  XFile? videoController;
  var bytes;
  // image picker code
  var scrollcontroller = ScrollController();
  File file = File('');
  String name = '';
  String file_path = '';
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
    // await Permission.storage.request();
    auth_token = prefs.getString('auth_token').toString();
    user_id = prefs.getString('user_id').toString();
    print('my auth token is-----------------$auth_token');
    print('my user id is-----------------$user_id');
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
          padding: EdgeInsets.only(
            top: 40.0,
            bottom: 10.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset('assets/icons/left.svg'),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Image.asset(
                        'assets/images/user_profile.png',
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
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
                            const SizedBox(
                              width: 6.0,
                            ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              // reverse: true,
              // reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  getmessagelist!.length < 0 ? 1 : getmessagelist!.length,
              itemBuilder: (BuildContext context, int index) {
                final path = getmessagelist![index].file;
                var ext = path?.split('.').last;
                return getmessagelist!.length < 0
                    ? const Center(
                        child: Text('No Chat Yet !'),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: getmessagelist![index].senderType == 'admin'
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/user_profile.png',
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                            color: AppColors.lightTextColor,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getmessagelist![index]
                                                    .message
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              Text(
                                                Utility().DatefomatToReferDate(
                                                    getmessagelist![index]
                                                        .createdAt
                                                        .toString()),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  getmessagelist![index].file == null
                                      ?
                                      // only text ↓ ↓
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14.0),
                                                  color: AppColors
                                                      .primaryLightColor,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      getmessagelist![index]
                                                          .message
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                    Text(
                                                      Utility()
                                                          .DatefomatToReferDate(
                                                              getmessagelist![
                                                                      index]
                                                                  .createdAt
                                                                  .toString()),
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          /*child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                              color:
                                                  AppColors.primaryLightColor,
                                            ),
                                            child: Text(
                                              getmessagelist![index]
                                                  .message
                                                  .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.white,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),*/
                                        )
                                      : getmessagelist![index].message == null
                                          // only file ↓ ↓
                                          ? Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  // image formats
                                                  ext == 'png' ||
                                                          ext == 'jpg' ||
                                                          ext == 'webp' ||
                                                          ext == 'svg' ||
                                                          ext == 'jpeg' ||
                                                          ext == 'gif' ||
                                                          ext == 'tiff'
                                                      ? Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: ((context) =>
                                                                          ImageViewer(
                                                                            imageUrl:
                                                                                getmessagelist![index].file.toString(),
                                                                          ))));
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14.0),
                                                              child:
                                                                  Image.network(
                                                                getmessagelist![
                                                                        index]
                                                                    .file
                                                                    .toString(),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.2,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : ext == 'pdf'
                                                          ? InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: ((context) =>
                                                                            PdfViewer(
                                                                              doc: getmessagelist![index].file.toString(),
                                                                            ))));
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/pdf.png',
                                                                height: 70.0,
                                                              ),
                                                            )
                                                          : ext == 'mp4' ||
                                                                  ext ==
                                                                      'mov' ||
                                                                  ext ==
                                                                      'mkv' ||
                                                                  ext == 'webm'
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: ((context) => VideoViewer(
                                                                                  url: getmessagelist![index].file.toString(),
                                                                                ))));
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/video5.png',
                                                                    height:
                                                                        70.0,
                                                                  ),
                                                                )
                                                              : ext == 'mp3' ||
                                                                      ext ==
                                                                          'wav'
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: ((context) => AudioViewer(audioUrl: getmessagelist![index].file.toString()))));
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/icons/audio.png',
                                                                        height:
                                                                            70.0,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      'something went wrong......'),
                                                  Text(
                                                    Utility()
                                                        .DatefomatToReferDate(
                                                            getmessagelist![
                                                                    index]
                                                                .createdAt
                                                                .toString()),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: AppColors
                                                          .primaryDarkColor,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            )
                                          // file and text ↓ ↓
                                          : Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  // image formats
                                                  ext == 'png' ||
                                                          ext == 'jpg' ||
                                                          ext == 'webp' ||
                                                          ext == 'svg' ||
                                                          ext == 'jpeg' ||
                                                          ext == 'gif' ||
                                                          ext == 'tiff'
                                                      ? Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: ((context) =>
                                                                          ImageViewer(
                                                                            imageUrl:
                                                                                getmessagelist![index].file.toString(),
                                                                          ))));
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14.0),
                                                              child:
                                                                  Image.network(
                                                                getmessagelist![
                                                                        index]
                                                                    .file
                                                                    .toString(),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.2,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : ext == 'pdf'
                                                          ? InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: ((context) =>
                                                                            PdfViewer(
                                                                              doc: getmessagelist![index].file.toString(),
                                                                            ))));
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/pdf.png',
                                                                height: 70.0,
                                                              ),
                                                            )
                                                          : ext == 'mp4' ||
                                                                  ext ==
                                                                      'mov' ||
                                                                  ext ==
                                                                      'mkv' ||
                                                                  ext == 'webm'
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: ((context) => VideoViewer(
                                                                                  url: getmessagelist![index].file.toString(),
                                                                                ))));
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/video5.png',
                                                                    height:
                                                                        70.0,
                                                                  ),
                                                                )
                                                              : ext == 'mp3' ||
                                                                      ext ==
                                                                          'wav'
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: ((context) => AudioViewer(audioUrl: getmessagelist![index].file.toString()))));
                                                                      },
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/icons/audio.png',
                                                                        height:
                                                                            70.0,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      'something went wrong......'),
                                                  Text(
                                                    Utility()
                                                        .DatefomatToReferDate(
                                                            getmessagelist![
                                                                    index]
                                                                .createdAt
                                                                .toString()),
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: AppColors
                                                          .primaryDarkColor,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14.0),
                                                      color: AppColors
                                                          .primaryLightColor,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          getmessagelist![index]
                                                              .message
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.white,
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                        Text(
                                                          Utility().DatefomatToReferDate(
                                                              getmessagelist![
                                                                      index]
                                                                  .createdAt
                                                                  .toString()),
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.white,
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Stack(
                                    children: [
                                      user == null ||
                                              user!.profileImage!.isEmpty
                                          ? Image.asset(
                                              'assets/images/chat_profile.png',
                                              width: 40.0,
                                              height: 40.0,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                              child: Image.network(
                                                user!.profileImage.toString(),
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
            const SizedBox(height: 75.0),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          right: 20.0,
          bottom: 20.0,
          left: 20.0,
        ),
        child: Container(
          height: 51.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Color(0xFFF0F0F0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              photoController != null
                  ? InkWell(
                      onTap: () {
                        openModal();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: Icon(Icons.photo,
                            color: AppColors.primaryLightColor, size: 30.0),
                      ),
                    )
                  : videoController != null
                      ? InkWell(
                          onTap: () {
                            openModal();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: Icon(Icons.photo,
                                color: AppColors.primaryLightColor, size: 30.0),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            bottom_bar(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/camera.svg',
                              width: 24.0,
                              height: 24.0,
                            ),
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
              InkWell(
                onTap: () {
                  name == '' ? pickFile() : attachmentModal();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/attach.svg',
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (messageController.text.isEmpty &&
                      photoController == null &&
                      videoController == null &&
                      name == '') {
                    UtilityToaster().getToast('Please Enter Something..');
                  } else {
                    sendmessageapi(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/send.svg',
                  ),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    auth_token = prefs.getString('auth_token').toString();
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.profileUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X-AUTHTOKEN": auth_token,
          "X-USERID": user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    ProfileModel responseprofile = await ProfileModel.fromJson(jsonResponse);
    if (responseprofile.status == true) {
      user = responseprofile.data!.userData!;
      // print('success contactSubmit');
      // UtilityToaster().getToast(responseprofile.message);
      setState(() {});
    } else {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    auth_token = prefs.getString('auth_token').toString();
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
          "X-AUTHTOKEN": auth_token,
          "X-USERID": user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    GetMessageModel responsegetmessage =
        await GetMessageModel.fromJson(jsonResponse);
    if (responsegetmessage.status == true) {
      getmessagelist = responsegetmessage.data!.messages;
      setState(() {});
    } else {
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
        "X-AUTHTOKEN": auth_token,
        "X-USERID": user_id,
      };
      request.headers.addAll(header);
      if(name != ''){
        print('file path is ------------------(file picker)' + file_path);
        if (file_path == null || file_path == 'null' || file_path == '') {
          request.fields['message'] = messageController.text;
        } else if (messageController.text.isEmpty) {
          request.files.add(await http.MultipartFile.fromPath('file', file_path));
        } else {
          request.fields['message'] = messageController.text;
          request.files.add(await http.MultipartFile.fromPath('file', file_path));
        }
      }else{
        if (photoController == null || photoController == 'null' || photoController == '') {
          if (videoController == null || videoController == 'null' || videoController == '') {
            request.fields['message'] = messageController.text;
          } else if (messageController.text.isEmpty) {
            request.files.add(await http.MultipartFile.fromPath('file', videoController!.path));
          } else {
            request.fields['message'] = messageController.text;
            request.files.add(await http.MultipartFile.fromPath('file', videoController!.path));
          }
        } else if(videoController == null || videoController == 'null' || videoController == '') {
          if (photoController == null || photoController == 'null' || photoController == '') {
            request.fields['message'] = messageController.text;
          } else if (messageController.text.isEmpty) {
            request.files.add(await http.MultipartFile.fromPath('file', photoController!.path));
          } else {
            request.fields['message'] = messageController.text;
            request.files.add(await http.MultipartFile.fromPath('file', photoController!.path));
          }
        }
      }
      request.fields['taskid'] = widget.task_id;
      request.fields['sender_id'] = widget.sender_id;
      var response = await request.send();
      Loader.ProgressloadingDialog(context, false);

      print("response is----------${response.headers.toString()}");
      response.stream.transform(convert.utf8.decoder).listen((event) {
        Map map = convert.jsonDecode(event);

        if (map["status"] == true) {
          UtilityToaster().getToast('Message sent successfully');
          getmessageapi(context);
          messageController = TextEditingController(text: '');
          photoController = null;
          videoController = null;
          name = '';
          setState(() {});
        } else {
          UtilityToaster().getToast('Message Not sent !');
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

  bottom_bar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text(
                'Image',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                //Navigator.pop(context);
                takeimage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_camera_back),
              title: Text('Video'),
              onTap: () {
                // Navigator.pop(context);
                makevideo(context, ImageSource.camera);
              },
            ),
          ]);
        });
  }

  // pick image
  Future takeimage(BuildContext context, imageSource) async {
    if (!kIsWeb) {
      var image =
          await imagePicker.pickImage(source: imageSource, imageQuality: 10);
      if (image == null) {
        print('+++++++++null');
        Navigator.pop(context);
        setState(() {});
      } else {
        photoController = XFile(image.path);
        print('image path is (main) ${photoController!.path}');
        UtilityToaster().getToast('Image Selected.');
        videoController = null;
        Navigator.pop(context);
        setState(() {});
      }
    } else if (kIsWeb) {
      // may be for ios
      var image =
          await imagePicker.pickImage(source: imageSource, imageQuality: 10);
      if (image == null) {
        print('+++++++++null');
        Navigator.pop(context);
        setState(() {});
      } else {
        photoController = XFile(image.path);
        print('image path is (main) ${photoController!.path}');
        UtilityToaster().getToast('Image Selected.');
        videoController = null;
        Navigator.pop(context);
        setState(() {});
      }
      setState(() {});
      print('image path is ${bytes}');
    }
  }

  ///Video picker...............
  Future makevideo(BuildContext context, imageSource) async {
    var video = await imagePicker.pickVideo(source: imageSource);
    if (!kIsWeb) {
      if (video == null) {
        print('+++++++++null');
        Navigator.pop(context);
        setState(() {});
      } else {
        videoController = XFile(video.path);
        print('video path is (main) ${videoController!.path}');
        photoController = null;
        Navigator.pop(context);
        UtilityToaster().getToast('Video Selected.');
        setState(() {});
      }
    } else if (kIsWeb) {
      if (video == null) {
        print('+++++++++null');
        Navigator.pop(context);
        setState(() {});
      } else {
        videoController = XFile(video.path);
        print('video path is (main) ${videoController!.path}');
        photoController = null;
        Navigator.pop(context);
        UtilityToaster().getToast('Video Selected.');
        setState(() {});
      }
      setState(() {});
      print('video path is ${bytes}');
    }
  }

  // open modal
  Future openModal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 50.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Colors.white),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              photoController != null
                  ? Column(
                      children: [
                        Image.file(
                          File(photoController!.path),
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ],
                    )
                  : videoController != null
                      ? Image.asset(
                          'assets/icons/video5.png',
                          height: 70.0,
                        )
                      : Text('Please select something.'),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // photoController == null ? makevideo(context, ImageSource.camera) : takeimage(context, ImageSource.camera);
                        bottom_bar(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        //height: MediaQuery.of(context).size.height * 0.06,
                        height: 50.0,
                        // width: 343.0,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDarkColor,
                          borderRadius: BorderRadius.circular(43.0),
                        ),
                        child: const Text(
                          'Retake',
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
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );
    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    print(result.files.first.size);
    print(result.files.first.path);
    file = new File(result.files.first.path.toString());
    name = result.files.first.name.toString();
    file_path = result.files.first.path.toString();
    setState(() {});
  }

  // open modal
  Future attachmentModal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 50.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Colors.white),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              name == null ? Text('Nothing selected.') : Text(name,textAlign: TextAlign.center,),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        pickFile();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        //height: MediaQuery.of(context).size.height * 0.06,
                        height: 50.0,
                        // width: 343.0,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDarkColor,
                          borderRadius: BorderRadius.circular(43.0),
                        ),
                        child: const Text(
                          'Retake',
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
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
