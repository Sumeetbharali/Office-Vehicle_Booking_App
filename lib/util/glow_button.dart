import 'package:flutter/material.dart';

class GlowButton extends StatelessWidget {
  final String iconPath;
  final String buttonText;
  final Widget destinationScreen; // New parameter to determine destination screen

  const GlowButton({
    Key? key,
    required this.iconPath,
    required this.buttonText,
    required this.destinationScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen), // Navigate to destinationScreen
        );
      },
      child: Column(
        children: [
          Container(
            height: 90,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white38,
                  blurRadius: 7,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(iconPath),
            ),
          ),
          SizedBox(height: 10),
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
