import 'package:flutter/material.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/Components/icon_box.dart';
import 'package:nu_parent/main.dart';
import 'package:nu_parent/oral_hygiene_babies.dart';
import 'package:nu_parent/oral_hygiene_children.dart';
import 'package:nu_parent/parent_oral.dart';
import 'package:nu_parent/pregnent_oral.dart';

class OralHygiene extends StatefulWidget {
  const OralHygiene({super.key});

  @override
  State<OralHygiene> createState() => _OralHygieneState();
}

class _OralHygieneState extends State<OralHygiene> {
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: ListView(
          children: [
            const CustomAppBar(),
            const Center(
              child: Text(
                "Dental Care",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
            ),
            Center(
                child: Image.asset(
              'assets/HappyTeeths.png',
              width: 300,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OralHygieneBabies()));
                    },
                    child: const IconBox(
                      image: 'assets/babyteeth.png',
                      title: 'Babies',
                      subtitle: '(0-3 years)',
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OralHygieneChildren(),
                          ));
                    },
                    child: const IconBox(
                      image: 'assets/happytooth.png',
                      title: 'Children',
                      subtitle: '(3-6 years)',
                    )),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PregnantOralHygiene(),
                          ));
                    },
                    child: const IconBox(
                        image: 'assets/pregnent.png',
                        title: 'Pregnant Mothers')),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ParentOralHygiene(),
                          ));
                    },
                    child: const IconBox(
                      image: 'assets/family.png',
                      title: 'Parents',
                      subtitle: 'Dental Care',
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
