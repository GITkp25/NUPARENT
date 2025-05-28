import 'package:flutter/material.dart';
import 'package:nu_parent/main.dart';
import 'package:nu_parent/settings.dart';

class CustomAppBar extends StatefulWidget {
  final Color bgColor;
  final bool settings;
  const CustomAppBar({super.key, this.bgColor=const Color.fromARGB(0, 255, 255, 255), this.settings = true});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, top: 10, bottom: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new)),
                if(widget.settings)
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: AppColors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsScreen()));
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
