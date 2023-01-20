import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:staid/views/app_colors.dart';
import 'package:staid/views/account/account.dart';
import 'package:staid/views/home/home.dart';
import 'package:staid/views/chat/chat.dart';
import 'package:staid/views/task/task.dart';
class Dashboard extends StatefulWidget {
  int bottomIndex;
  Dashboard({Key? key, required this.bottomIndex}) : super(key: key);
  @override
  State<Dashboard> createState() => _HomeState();
}
var widgetOptions = [
  const Home(),
  const Taskbar(),
  const Chat(),
  const Account(),
];


class _HomeState extends State<Dashboard> {
  // int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {


    void _onItemTapped(int index) {
      setState(() {
        widget.bottomIndex = index;
        // print("index>>>>${_selectedIndex}");
      });
    }
    return Scaffold(
      body: widgetOptions[
      widget.bottomIndex
      ],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(43.0)),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: widget.bottomIndex == 0 ?
                  Image.asset('assets/icons/home_selected.png',width: 20.0,height: 20.0,) :
                  Image.asset('assets/icons/home_unselected.png',width: 20.0,height: 20.0,),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: widget.bottomIndex == 1 ?
                Image.asset('assets/icons/clipboard_selected.png',width: 20.0,height: 20.0,) :
                Image.asset('assets/icons/clipboard_unselected.png',width: 20.0,height: 20.0,),
                label: 'Clipboard',
              ),
              BottomNavigationBarItem(
                icon: widget.bottomIndex == 2 ?
                Image.asset('assets/icons/chat_selected.png',width: 20.0,height: 20.0,) :
                Image.asset('assets/icons/chat_unselected.png',width: 20.0,height: 20.0,),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: widget.bottomIndex == 3 ?
                Image.asset('assets/icons/user_selected.png',width: 20.0,height: 20.0,) :
                Image.asset('assets/icons/user_unselected.png',width: 20.0,height: 20.0,),
                label: 'Account',
              ),
            ],
            currentIndex: widget.bottomIndex,
            elevation: 0.0,
            backgroundColor: AppColors.primaryDarkColor,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: AppColors.unselectedColor,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
