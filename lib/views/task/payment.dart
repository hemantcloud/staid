import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/dashboard.dart';
import 'package:staid/views/task/task.dart';
class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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
                    'Payment',
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: ((context) => const PostATask())));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0,),
                      child: Container(
                        padding: EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/payment_bg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Want To Create My Assignment',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10.0,),
                            const Text(
                              '\$ 1600',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            InkWell(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: ((context) => const Payment())));
                                popupReject();
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            const Align(
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
            const SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.transparent,
                border: Border.all(
                  width: 1.0,
                  color: AppColors.inputBorderColor,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/transaction.png',width: 56.0,height: 56.0,),
                  const SizedBox(width: 20.0,),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Transaction',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackDarkColor,
                          ),
                        ),
                        Text(
                          '08-12-2022',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackLightColor,
                          ),
                        ),
                        Text(
                          '17:00',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0,),
                  Text(
                    '\$7515',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLightColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.transparent,
                border: Border.all(
                  width: 1.0,
                  color: AppColors.inputBorderColor,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/transaction.png',width: 56.0,height: 56.0,),
                  const SizedBox(width: 20.0,),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Transaction',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackDarkColor,
                          ),
                        ),
                        Text(
                          '08-12-2022',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackLightColor,
                          ),
                        ),
                        Text(
                          '17:00',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0,),
                  Text(
                    '\$7515',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLightColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.transparent,
                border: Border.all(
                  width: 1.0,
                  color: AppColors.inputBorderColor,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/transaction.png',width: 56.0,height: 56.0,),
                  const SizedBox(width: 20.0,),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Transaction',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackDarkColor,
                          ),
                        ),
                        Text(
                          '08-12-2022',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackLightColor,
                          ),
                        ),
                        Text(
                          '17:00',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0,),
                  Text(
                    '\$7515',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLightColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.transparent,
                border: Border.all(
                  width: 1.0,
                  color: AppColors.inputBorderColor,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/transaction.png',width: 56.0,height: 56.0,),
                  const SizedBox(width: 20.0,),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Transaction',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackDarkColor,
                          ),
                        ),
                        Text(
                          '08-12-2022',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackLightColor,
                          ),
                        ),
                        Text(
                          '17:00',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20.0,),
                  Text(
                    '\$7515',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLightColor,
                    ),
                  ),
                ],
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
