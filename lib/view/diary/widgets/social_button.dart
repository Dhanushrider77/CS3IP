
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/pallete.dart';


class SocialButton extends StatelessWidget {
  final String iconpath;
  final String lable;
  const SocialButton({super.key, required this.iconpath, required this.lable});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: SvgPicture.asset(
        iconpath,
        width: 25,
        color: Pallete.gradient2,
      ),
      label: Text(
        lable,
        style: const TextStyle(
          color: Pallete.gradient3,
          fontSize: 17,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Pallete.borderColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
