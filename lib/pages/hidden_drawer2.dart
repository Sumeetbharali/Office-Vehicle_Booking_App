import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:nic_yaan/pages/settings.dart';
import 'package:nic_yaan/screens/HomePage.dart';

import '../screens/approverHOme.dart';
class HiddenDrawer2 extends StatefulWidget {
  const HiddenDrawer2({super.key});

  @override
  State<HiddenDrawer2> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer2> {

  List<ScreenHiddenDrawer> _pages=[];

  @override
  void initState() {

    super.initState();
    _pages = [
      ScreenHiddenDrawer(ItemHiddenMenu(
        name: 'HOME',
        baseStyle:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
        selectedStyle: TextStyle(),
        colorLineSelected: Colors.deepPurple,
      ), HomePageApp()),
      ScreenHiddenDrawer(ItemHiddenMenu(
        name: 'Settings',
        baseStyle:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
        selectedStyle: TextStyle(),
        colorLineSelected: Colors.deepPurple,
      ), Settings())

    ];
  }

  @override
  Widget build(BuildContext context) {
    return  HiddenDrawerMenu(
      backgroundColorMenu: Colors.black87,
      screens:_pages,
      initPositionSelected: 0,
      slidePercent: 40,
    );
  }
}
