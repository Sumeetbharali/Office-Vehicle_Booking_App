import 'package:flutter/material.dart';
import 'package:nic_yaan/pages/change_password.dart';
import 'package:nic_yaan/pages/google_map_page.dart';
import 'package:nic_yaan/pages/hidden_drawer.dart';
import 'package:nic_yaan/pages/hidden_drawer2.dart';
import 'package:nic_yaan/pages/landing.dart';
import 'package:nic_yaan/pages/role_selection_page.dart';
import 'package:nic_yaan/pages/settings.dart';
import 'package:nic_yaan/screens/HomePage.dart';
import 'package:nic_yaan/screens/approver.dart';
import 'package:nic_yaan/screens/booking.dart';
import 'package:nic_yaan/screens/check.dart';
import 'package:nic_yaan/screens/driver.dart';
import 'package:nic_yaan/screens/loading.dart';
import 'package:nic_yaan/screens/approverHOme.dart';
import 'package:nic_yaan/screens/login.dart';
import 'package:nic_yaan/screens/reservation.dart';
import 'package:nic_yaan/screens/trip.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF000000, {
          50: Colors.black,
          100: Colors.black,
          200: Colors.black,
          300: Colors.black,
          400: Colors.black,
          500: Colors.black,
          600: Colors.black,
          700: Colors.black,
          800: Colors.black,
          900: Colors.black,
        }),
      ),
      routes: {
        '/hidden': (context) => const HiddenDrawer(),
        '/load': (context)=> LoadingPage(),
        '/change': (context)=> ChangePasswordScreen(),
        '/log': (context)=> LoginPage(),
        // Other routes...
      },
    );
  }
}
