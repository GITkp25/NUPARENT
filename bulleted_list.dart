import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final String text;
  final Color textColor;

  const BulletList(
      {Key? key, required this.text, this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(6.0),
            child: Icon(
              Icons.circle,
              size: 8,
            ),
          ),
          Expanded(
            child: Text(text, style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }
}
