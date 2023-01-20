import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/app_colors.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  String imageUrl;
  ImageViewer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
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
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Image view',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        elevation: 0.0,
      ),
      /*body: Image.network(
        widget.imageUrl,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),*/
      body: PhotoView(
        imageProvider: NetworkImage(widget.imageUrl),
      ),
    );
  }
}
