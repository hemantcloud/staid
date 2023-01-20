// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/app_colors.dart';

class AudioViewer extends StatefulWidget {
  String audioUrl;
  AudioViewer({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<AudioViewer> createState() => _AudioViewerState();
}

class _AudioViewerState extends State<AudioViewer> {
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
                      'Audio view',
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
        widget.audioUrl,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/audio.png',
              height: 70.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      final player = AudioPlayer();
                      await player.play(UrlSource(widget.audioUrl));
                      setState(() {});
                      // _launchUrl;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      //height: MediaQuery.of(context).size.height * 0.06,
                      height: 50.0,
                      // width: 343.0,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDarkColor,
                        borderRadius: BorderRadius.circular(43.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          Text(
                            'Play',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      final player = AudioPlayer();
                      await player.stop();
                      setState(() {});
                      // _launchUrl;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      //height: MediaQuery.of(context).size.height * 0.06,
                      height: 50.0,
                      // width: 343.0,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDarkColor,
                        borderRadius: BorderRadius.circular(43.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pause,
                            color: Colors.white,
                          ),
                          Text(
                            'Stop',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
