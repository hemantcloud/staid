import 'package:flutter/material.dart';
import 'package:staid/views/app_colors.dart';


class Loader {

  static ProgressloadingDialog(BuildContext context,bool status) {
    if(status){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: /*CircleAvatar(
                radius: 50,
              backgroundColor: MainColor.ColorBlueapp,
              child: Image.asset("assets/images/pilot_plan_loader.gif",height: 50,width: 50,fit: BoxFit.fill,),
              )*/
              CircularProgressIndicator(color: AppColors.primaryDarkColor,),
            );
          });
      // return pr.show();
    }else{
      Navigator.pop(context);
      // return pr.hide();
    }
  }
  static  hideKeyboard(){
    FocusManager.instance.primaryFocus?.unfocus();
  }
}