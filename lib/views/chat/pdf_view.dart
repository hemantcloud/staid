// ignore_for_file: prefer_const_constructors

import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/app_colors.dart';

class PdfViewer extends StatefulWidget {
  final doc;
  const PdfViewer({@required this.doc, Key? key}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool isLoading = true;
  var document;
  PDFDocument? document1;
  //final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PDFPage? pageOne;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      document1 = await PDFDocument.fromURL(widget.doc);
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar  (
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
                      'PDF view',
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
      body: Center(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document1!)),
    );
  }
}
