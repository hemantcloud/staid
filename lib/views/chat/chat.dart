import 'package:flutter/material.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/chat/chat_list_with_task_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/chat/chat_screen.dart';
import 'dart:convert' as convert;

import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<ChatlistWithTask>? chatlistwithtask= [];
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
      chatlistwithtaskapi(context);
      auth_token = prefs.getString('auth_token').toString();
      user_id = prefs.getString('user_id').toString();
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
        flexibleSpace: const Padding(
          padding: EdgeInsets.only(top: 40.0,bottom: 10.0,left: 20.0,right: 20.0,),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Chat',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0,),
        child: Column(
          children: [
            // const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: chatlistwithtask!.length < 0 ? 1 : chatlistwithtask!.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  chatlistwithtask!.length <= 0 ?
                  const Center(
                    child: Text('No Chat List Yet !'),
                  ) :
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatScreen(
                        sender_id: chatlistwithtask![index].userId,
                        task_id: chatlistwithtask![index].id.toString(),
                      ))));
                    },
                    child: Container(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 70.0,
                            height: 70.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryDarkColor,width: 1.0,),
                            ),
                            child: Image.network(
                              chatlistwithtask![index].categoryImage.toString(),
                              width: 58.0,
                              height: 58.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 10.0,),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatlistwithtask![index].name.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'poppins',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blackDarkColor,
                                  ),
                                ),
                                Text(
                                  chatlistwithtask![index].description.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blackLightColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0,),
                        ],
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
  // task list api
  Future<void> chatlistwithtaskapi(BuildContext context) async {
    chatlistwithtask!.clear();
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.chatListWithTaskUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X-AUTHTOKEN" : auth_token,
          "X-USERID" : user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    ChatListWIthTaskModel responsechatlistwithtask = await ChatListWIthTaskModel.fromJson(jsonResponse);
    if(responsechatlistwithtask.status == true){
      if(responsechatlistwithtask.message != 'Success'){
        UtilityToaster().getToast(responsechatlistwithtask.message);
      }
      chatlistwithtask  = responsechatlistwithtask!.data!.chatlistWithTask;
      setState(() {});
    }else{
      UtilityToaster().getToast(responsechatlistwithtask.message);
      setState(() {});
    }
    return;
  }
}
