import 'package:flutter/material.dart';
import 'package:nu_parent/Components/topbar.dart';
import 'package:nu_parent/child_registration.dart';
import 'package:nu_parent/main.dart';

class ChildProfilePop extends StatefulWidget {
  final String docId;

  const ChildProfilePop({Key? key, required this.docId}) : super(key: key);

  @override
  _ChildProfilePopState createState() => _ChildProfilePopState();
}

class _ChildProfilePopState extends State<ChildProfilePop> {
  late String _receivedDocId;

  @override
  void initState() {
    super.initState();
    _receivedDocId = widget.docId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 175, 203, 244),
            ],
            stops: [0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          children: [
            CustomTopBar(
                showBackIcon: false,
                showNotificationButton: false,
                docId: _receivedDocId),
            Stack(
              children: [
                Image.asset('assets/FamilyBrushing.jpg'),
                Positioned(
                  top: 10,
                  left: 20,
                  child: Image.asset(
                    'assets/Logo.png',
                    width: 80,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Enter your Child's information",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Please complete your profile",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationChild(
                                      docId: _receivedDocId,
                                      action: 'REGISTER',
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.fromLTRB(0.0, 15, 0.0, 15),
                      ),
                      child: const Text(
                        'UPDATE NOW',
                        style: TextStyle(fontSize: 16, color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
