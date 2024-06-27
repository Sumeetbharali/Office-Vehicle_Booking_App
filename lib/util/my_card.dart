import 'package:flutter/material.dart';

class MyCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const MyCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 300,
        height: 200, // Set the height of the card
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87, // Background color for the card
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  widget.title,
                  style: TextStyle(color: Colors.white), // Text color
                ),
                SizedBox(height: 10),
                Text(
                  widget.subtitle,
                  style: TextStyle(color: Colors.white, fontSize: 20), // Text color
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Image.asset(
                widget.imagePath,
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
