import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/task/post_a_task_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/dashboard.dart';
import 'package:staid/views/task/task.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;
class PostATask extends StatefulWidget {
  final category_id;
  final category_name;
  PostATask({Key? key,required this.category_id,required this.category_name}) : super(key: key);

  @override
  State<PostATask> createState() => _PostATaskState();
}

class _PostATaskState extends State<PostATask> {
  var taskNameController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  var taskDurationController = TextEditingController();
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
      print("category id is ***" + widget.category_id);
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
                    'Post A Task',
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
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
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
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            // textAlignVertical: TextAlignVertical.bottom,
                            controller: taskNameController,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Poppins',
                              color: AppColors.lightTextColor,
                            ),
                            cursorColor: AppColors.lightTextColor,
                            decoration: const InputDecoration(
                              hintText: 'Task Name',
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
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0,),
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
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: taskDescriptionController,
                            maxLines: 6,
                            // textAlignVertical: TextAlignVertical.bottom,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Poppins',
                              color: AppColors.lightTextColor,
                            ),
                            cursorColor: AppColors.lightTextColor,
                            decoration: const InputDecoration(
                              hintText: 'Task Description',
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
                ),
              ],
            ),
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
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      // textAlignVertical: TextAlignVertical.bottom,
                      keyboardType: TextInputType.datetime,
                      controller: taskDurationController,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Poppins',
                        color: AppColors.lightTextColor,
                      ),
                      cursorColor: AppColors.lightTextColor,
                      decoration: const InputDecoration(
                        hintText: 'Task Duration in Hrs',
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
                    margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                    child: SvgPicture.asset('assets/icons/select_dropdown.svg',),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 57.0,
              width: MediaQuery.of(context).size.width * 1,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.transparent,
                border: Border.all(
                  width: 1.0,
                  color: AppColors.inputBorderColor,
                  style: BorderStyle.solid,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.category_name,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Poppins',
                    color: AppColors.lightTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            InkWell(
              onTap: () {
                String taskname = taskNameController.text;
                String taskdescription = taskDescriptionController.text;
                String taskduration = taskDurationController.text;
                if(taskname.isEmpty){
                  UtilityToaster().getToast("Please Enter Task Name.");
                } else if(taskdescription.isEmpty){
                  UtilityToaster().getToast("Please Enter Task Description.");
                } else if(taskduration.isEmpty){
                  UtilityToaster().getToast("Please Enter Task Duration.");
                }else{
                  addtask(context);
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
                  'Post',
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
  Future bootstrapModal() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50.0,),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Colors.white),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width * 1,
          height: 350.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/verification_successfully.png',width: 77.0,height: 77.0),
              const Text(
                'Sucessfully!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Admin will approve soon',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => const Taskbar())));
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
  // add a task api
  Future<void> addtask(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    request['categoryid'] = widget.category_id;
    request['name'] = taskNameController.text;
    request['description'] = taskDescriptionController.text;
    request['duration'] = taskDurationController.text;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.postATaskUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "X-AUTHTOKEN" : auth_token,
          "X-USERID" : user_id,
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    PostATaskModel responsepostatask = await PostATaskModel.fromJson(jsonResponse);
    if(responsepostatask.status == true){
      // UtilityToaster().getToast(responsepostatask.message);
      setState(() {});
      bootstrapModal();
    }else{
      UtilityToaster().getToast(responsepostatask.message);
      setState(() {});
    }
    return;
  }
}
