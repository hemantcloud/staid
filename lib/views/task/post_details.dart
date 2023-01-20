import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/dashboard.dart';
import 'package:staid/views/task/task.dart';
class TaskDetails extends StatefulWidget {
  String category_name;
  String task_name;
  String task_description;
  String task_duration;
  String task_status;
  TaskDetails({Key? key,required this.category_name,required this.task_name,required this.task_description,required this.task_duration,required this.task_status,}) : super(key: key);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
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
                    'Task Details',
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
            // task category
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Task Category',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
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
                    fontFamily: 'Poppins',
                    color: AppColors.blackLightColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // task name
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Task Name',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
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
                  widget.task_name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.blackLightColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // task description
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Task Description',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
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
                  widget.task_description,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.blackLightColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // task duration
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Task Duration',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
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
                    widget.task_duration + ' Hrs',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.blackLightColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // task status
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Task Status',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
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
                  widget.task_status == 'active' ?
                  'Approved' :
                  widget.task_status == 'decline' ?
                  'Approved' :
                  'Pending',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.blackLightColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
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
  Future popupReject() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
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
          width: MediaQuery.of(context).size.width * 1,
          height: 250.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Amount',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDarkColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                '\$800',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                  color: AppColors.primaryDarkColor,
                ),
                textAlign: TextAlign.center,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => Dashboard(bottomIndex: 2,))));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  //height: MediaQuery.of(context).size.height * 0.06,
                  height: 43.0,
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
            ],
          ),
        ),
      ),
    );
  }
}
