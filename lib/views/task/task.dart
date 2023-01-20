import 'package:flutter/material.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staid/models/task/task_list_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/task/payment.dart';
import 'package:staid/views/task/post_details.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;

class Taskbar extends StatefulWidget {
  const Taskbar({Key? key}) : super(key: key);

  @override
  State<Taskbar> createState() => _TaskbarState();
}

class _TaskbarState extends State<Taskbar> {
  List<Task>? tasklist= [];
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
        toolbarHeight: 70.0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryLightColor,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 40.0,bottom: 10.0,left: 20.0,right: 20.0,),
          child: Align(
            alignment: Alignment.center,
            child: const Text(
              'Posted Task',
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
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasklist!.length < 0 ? 1 : tasklist!.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  tasklist!.length < 0 ?
                  const Center(
                    child: Text('No Tasks Yet'),
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
                    margin: const EdgeInsets.only(bottom: 10.0,),
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
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
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
