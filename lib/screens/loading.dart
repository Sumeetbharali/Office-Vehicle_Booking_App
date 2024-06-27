import 'package:flutter/material.dart';
import 'package:nic_yaan/pages/hidden_drawer2.dart';
import 'package:nic_yaan/pages/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart'; // Adjust the path as needed
import '../util/token_check.dart';
import 'driver.dart';
import 'approver.dart';
import 'package:nic_yaan/pages/hidden_drawer.dart';
import 'login.dart'; // Adjust the path as needed


class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    checkTokenAndNavigate();
  }

  Future<void> checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String? role = prefs.getString('role');
    String? name = prefs.getString('name'); // Retrieve the name if needed

    if (token != null && !isTokenExpired(token)) {
      // Token is present and not expired
      if (role != null) {
        // Navigate to the respective page based on the role
        switch (role) {
          case 'driver':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DriverPage(),
              ),
            );
            break;
          case 'first_approver':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HiddenDrawer2(), // Pass the token if needed
              ),
            );
            break;
          case 'second_approver':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HiddenDrawer2(), // Pass the token if needed
              ),
            );
            break;
          case 'user':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HiddenDrawer(),
              ),
            );
            break;
          default:
          // Handle unexpected role
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LandingPage(),
              ),
            );
            break;
        }
      } else {
        // If no role is found, navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LandingPage(),
          ),
        );
      }
    } else {
      // Token is either null or expired, navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
