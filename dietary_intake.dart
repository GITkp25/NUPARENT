import 'package:flutter/material.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/dietary_intake_birth.dart';
import 'package:nu_parent/dietary_intake_one.dart';
import 'package:nu_parent/dietary_intake_two.dart';
import 'package:nu_parent/expecting_mothers.dart';
import 'package:nu_parent/main.dart';

class DietaryIntake extends StatefulWidget {
  const DietaryIntake({super.key});

  @override
  State<DietaryIntake> createState() => _DietaryIntakeState();
}

bool check = false;

class _DietaryIntakeState extends State<DietaryIntake> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            color: AppColors.white,
            image: DecorationImage(
              image: AssetImage('assets/Vector-1.png'),
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            )),
        child: ListView(children: [
          const CustomAppBar(),
          const Center(
            child: Text(
              "Your Child’s Dietary Intake",
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/Eating.png',
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpectingMother()));
                  },
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ]),
                    child: const Center(
                      child: Text(
                        'Expecting Mothers',
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DietaryIntakeBirth(),
                        ));
                  },
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ]),
                    child: const Center(
                      child: Text(
                        'From Birth to the First Year of Age',
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DietaryIntakeOne(),
                        ));
                  },
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ]),
                    child: const Center(
                      child: Text(
                        'First and Second Year of Age',
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DietaryIntakeTwo(),
                        ));
                  },
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ]),
                    child: const Center(
                      child: Text(
                        'From Two to Six Years of Age',
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
