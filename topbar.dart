// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nu_parent/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomTopBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  final bool showNotificationButton;
  final String docId;

  const CustomTopBar(
      {Key? key,
      required this.docId,
      this.showBackIcon = true,
      this.showNotificationButton = true})
      : super(key: key);

  @override
  State<CustomTopBar> createState() => _CustomTopBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _CustomTopBarState extends State<CustomTopBar> {
  String name = "";
  late String _receivedDocId;
  String image = 'assets/dummy-profile-pic.png';

  Size get preferredSize => widget.showBackIcon
      ? const Size.fromHeight(110)
      : const Size.fromHeight(80);

  @override
  void initState() {
    super.initState();
    _receivedDocId = widget.docId;
    if (_receivedDocId != "") {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(_receivedDocId);
      userDoc.get().then((documentSnapshot) {
        if (documentSnapshot.exists) {
          final userData = documentSnapshot.data();
          setState(() {
            name = userData?['name'] ?? 'Name not Found';
            if (userData?['imageUrl'] != null) {
              image = userData?['imageUrl'];
            }
          });
        }
      }).catchError((error) {
        // Handle any potential errors
        print('Error retrieving user data: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 40, 18, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: [
                        SizedBox(
                          child: (image != "assets/dummy-profile-pic.png"
                              ? Image.network(image,
                                  height: 50, width: 50, fit: BoxFit.cover)
                              : Image.asset('assets/dummy-profile-pic.png',
                                  height: 50, width: 50, fit: BoxFit.cover)),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 35, top: 35),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.green,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hello,'),
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: widget.showNotificationButton
                        ? AppColors.whiteblue
                        : null,
                    borderRadius: BorderRadius.circular(8.0)),
                child: widget.showNotificationButton
                    ? GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Skip',
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
        if (widget.showBackIcon)
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new), //Back Icon
              ),
            ],
          ),
      ],
    );
  }
}
