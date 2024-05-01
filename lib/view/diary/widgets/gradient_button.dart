import 'package:flutter/material.dart';

import '../utils/pallete.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width, height;
  const GradientButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width = 300,
      this.height = 70});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Pallete.gradient1,
            Pallete.gradient2,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          maximumSize: Size(width, height),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
