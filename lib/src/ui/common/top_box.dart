import 'package:flutter/material.dart';

class TopBox extends StatelessWidget {
  const TopBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0abab5),
      height: 80,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // inset from edges
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/side_image.png', // left image
              height: 60,
              width: 60,
            ),
            Image.asset(
              'assets/center_image.png', // center image
              height: 180,
              width: 180, // adjust to fit the row
            ),
            Image.asset(
              'assets/side_image.png', // right image
              height: 60,
              width: 60,
            ),
          ],
        ),
      ),
    );
  }
}
