// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:staid/models/account/profile_model.dart';
import 'package:staid/models/home/category_model.dart';
import 'package:staid/models/task/task_list_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/home/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/views/task/direct_post_a_task.dart';
import 'package:staid/views/task/payment.dart';
import 'package:staid/views/task/post_details.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'dart:convert' as convert;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:staid/views/utilities/urls.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Category>? categorylist= [];
  List<Task>? tasklist= [];

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
      categoryapi(context);
      tasklistapi(context);
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
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: AppColors.primaryDarkColor,
        // ),
        toolbarHeight: 70.0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryLightColor,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 40.0,bottom: 10.0,left: 20.0,right: 20.0,),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        user == null || user!.profileImage!.isEmpty?
                        Image.asset(
                          'assets/images/chat_profile.png',
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
                        )                        ,
                      ],
                    ),
                    const SizedBox(width: 10.0,),
                    Text(
                      user == null ? 'Hii ' : 'Hii ' + user!.name.toString(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/icons/notification.svg',
                  color: Colors.white,
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ],
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0,),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => const Categories())));
                    },
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.primaryLightColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2/2,
                  childAspectRatio: 8/9,
                ),
                itemCount: categorylist!.length > 0 ? 4 : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:  EdgeInsets.only(top: 10.0,bottom: 10.0,right: 5.0,left: 5.0,),
                    child: Container(
                      height: 170.0,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: AppColors.primaryLightColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70.0,
                            height: 70.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
                            child: Image.network(
                              categorylist![index].image.toString(),
                              width: 58.0,
                              height: 58.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            categorylist![index].name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0,),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Task',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasklist!.length < 0 ? 1 : tasklist!.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  tasklist!.length < 0 ?
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text('No Tasks Yet !'),
                  ) :
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => TaskDetails(
                        category_name: tasklist![index].categoryName.toString(),
                        task_name: tasklist![index].name.toString(),
                        task_description: tasklist![index].description.toString(),
                        task_duration: tasklist![index].duration.toString(),
                        task_status: tasklist![index].status.toString(),
                      ))));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 10.0,left: 20.0,right: 20.0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: Colors.transparent,
                        border: Border.all(
                          width: 1.0,
                          color: AppColors.inputBorderColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  tasklist![index].name.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'poppins',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blackDarkColor,
                                  ),
                                ),
                              ),
                              Text(
                                tasklist![index].status.toString() == 'active' ?
                                'Approved' :
                                tasklist![index].status.toString() == 'decline' ?
                                'Declined' :
                                'Pending',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color:
                                  tasklist![index].status.toString() == 'active' ?
                                  Colors.green :
                                  tasklist![index].status.toString() == 'decline' ?
                                  Colors.red :
                                  Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tasklist![index].categoryName.toString(),
                                style: const TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackLightColor,
                                ),
                              ),
                              tasklist![index].status.toString() == 'active' ?
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: ((context) => const Payment())));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0,),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    // color: AppColors.disabledButtonColor,
                                    color: AppColors.primaryLightColor,
                                  ),
                                  child: const Text(
                                    'Pay',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ) :
                              tasklist![index].status.toString() == 'decline' ?
                              Container() :
                              InkWell(
                                onTap: (){
                                  UtilityToaster().getToast('Task is Pending......');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0,),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: AppColors.disabledButtonColor,
                                    // color: AppColors.primaryLightColor,
                                  ),
                                  child: const Text(
                                    'Pay',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            tasklist![index].duration.toString() + ' Hrs',
                            // tasklist![index].duration.toString() + ' Hrs' + tasklist![index].status.toString(),
                            style: const TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackLightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0,),
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryLightColor,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: ((context) => const DirectPostATask())));
          },
          tooltip: 'Add',
          child: const Icon(Icons.add),
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

  // category api
  Future<void> categoryapi(BuildContext context) async {
    categorylist!.clear();
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.categoryUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X_CLIENT" : Urls.x_client_token,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    CategoryModel responsecategory = await CategoryModel.fromJson(jsonResponse);
    if(responsecategory.status == true){
      categorylist  = responsecategory.data!.category;
      setState(() {});
    }else{
      UtilityToaster().getToast(responsecategory.message);
      setState(() {});
    }
    return;
  }
  // task list api
  Future<void> tasklistapi(BuildContext context) async {
    tasklist!.clear();
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.taskListUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X-AUTHTOKEN" : auth_token,
          "X-USERID" : user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    TaskListModel responsetasklist = await TaskListModel.fromJson(jsonResponse);
    if(responsetasklist.status == true){
      tasklist  = responsetasklist!.data!.task;
      setState(() {});
    }else{
      UtilityToaster().getToast(responsetasklist.message);
      setState(() {});
    }
    return;
  }
}
