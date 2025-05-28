import 'package:flutter/material.dart';

class BottomFooter extends StatelessWidget {
  const BottomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Image.asset(
        'assets/Vector-new.png',
        fit: BoxFit.fill,
        alignment: Alignment.bottomLeft,
      ),
    );
  }
}
