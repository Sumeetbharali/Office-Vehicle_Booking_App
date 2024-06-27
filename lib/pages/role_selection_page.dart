import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../screens/login.dart';
import '../util/my_card.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();

    return Scaffold(
      body: Container(
        color: Colors.grey.shade200, // Set the background color
        child: Column(
          children: [
            SizedBox(height: 40),
            Image.asset(
              'assets/images/logono.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 80), // Add some space
            Container(
              height: 200, // Set the height for the PageView
              child: PageView(
                controller: _controller,
                children: [
                  buildCard('User', 'Log in as a User', 'assets/images/profile.png', context),
                  buildCard('Driver', 'Log in as a Driver', 'assets/images/driver.png', context),
                  buildCard('Approver', 'Log in as a Approver', 'assets/images/approve.png', context),
                ],
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.black,
                  dotColor: Colors.white.withOpacity(0.9),
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),
            SizedBox(height: 10), // Add some space
            Icon(Icons.arrow_right_alt, color: Colors.black),
            SizedBox(height: 10), // Add some space
            Text(
              'Swipe and choose your role',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),// Arrow icon
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, String subtitle, String imagePath, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: MyCard(
        title: title,
        subtitle: subtitle,
        imagePath: imagePath,
        onTap: () => _selectRole(title, context),
      ),
    );
  }

  void _selectRole(String role, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_role', role);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

