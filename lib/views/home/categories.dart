import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:staid/models/home/category_model.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/task/post_a_task.dart';
import 'package:staid/views/utilities/custom_loader.dart';
import 'package:staid/views/utilities/toast.dart';
import 'package:staid/views/utilities/urls.dart';
import 'dart:convert' as convert;
class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Category>? categorylist= [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      this.categoryapi(context);
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
                    'Category',
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
        padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0,),
        child: Column(
          children: [
            // const SizedBox(height: 20.0),
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
                itemCount: categorylist!.length > 0 ? categorylist!.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => PostATask(
                        category_id: categorylist![index].id.toString(),
                        category_name: categorylist![index].name.toString(),
                      ))));
                    },
                    child: Padding(
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
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
  // category api
  Future<void> categoryapi(BuildContext context) async {
    // categorylist!.clear();
    Loader.ProgressloadingDialog(context, true);
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
}
