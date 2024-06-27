import 'package:flutter/material.dart';

class List_tile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subTitle;
  final VoidCallback? onTap;

  const List_tile({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.subTitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom:25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(iconPath),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 12),
                    Text(
                      subTitle,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(width: 30),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
