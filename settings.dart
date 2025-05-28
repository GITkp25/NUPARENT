// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/Reminder.dart';
import 'package:nu_parent/brushing_instruction.dart';
import 'package:nu_parent/dental_visit.dart';
import 'package:nu_parent/dietary_intake.dart';
import 'package:nu_parent/howtovideos.dart';
import 'package:nu_parent/login_screen.dart';
import 'package:nu_parent/main.dart';
import 'package:nu_parent/oral_hygiene.dart';
import 'package:nu_parent/timer.dart';
import 'package:nu_parent/view_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

bool check = false;

class _SettingsScreenState extends State<SettingsScreen> {
  bool isHomeListVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/Vector-1.png'),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        )),
        child: ListView(
          children: [
            const CustomAppBar(
              settings: false,
            ),
            const SizedBox(
                height: 80,
                child: Center(
                    child: Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                ))),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ViewProfile()));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 83, 128, 196)),
                child: const Text(
                  "Child Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isHomeListVisible = !isHomeListVisible;
                });
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 220, 231, 253)),
                child: const Text(
                  "Home",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (isHomeListVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OralHygiene()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: const BoxDecoration(color: AppColors.white),
                      child: const Text(
                        "Oral Hygiene",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DietaryIntake()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: const BoxDecoration(color: AppColors.white),
                      child: const Text(
                        "Dietary Intake",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BrushingInstruction()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: const BoxDecoration(color: AppColors.white),
                      child: const Text(
                        "Brushing Instruction",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DentalVisit()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: const BoxDecoration(color: AppColors.white),
                      child: const Text(
                        "Dental Visit",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HowToVideos()));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 83, 128, 196)),
                child: const Text(
                  "How to Videos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const Reminder())));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 220, 231, 253)),
                child: const Text(
                  "Reminders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CountdownPage()));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 83, 128, 196)),
                child: const Text(
                  "Timers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 220, 231, 253)),
              child: const Text(
                "Contact",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 83, 128, 196)),
              child: const Text(
                "Share",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 220, 231, 253)),
              child: const Text(
                "Rate the app",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                _logout();
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                  color: Colors.red, // Customize the color as needed
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    // Clear saved data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear(); // This will remove all key-value pairs

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
