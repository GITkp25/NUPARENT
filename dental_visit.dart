import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/Components/box.dart';
import 'package:nu_parent/Components/footer.dart';
import 'package:nu_parent/Reminder.dart';
import 'package:nu_parent/main.dart';

class DentalVisit extends StatefulWidget {
  const DentalVisit({Key? key}) : super(key: key);

  @override
  State<DentalVisit> createState() => _DentalVisitState();
}

class _DentalVisitState extends State<DentalVisit> {
  FlutterTts flutterTts = FlutterTts();

  Future speak(String stext) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(stext);
  }

  final List<String> item1 = [
    'Exam of your child’s teeth and gums',
    'Tips for caring for your child’s mouth',
    'Advice for safely suing fluoride',
    'Planning for future dental visits',
  ];
  final List<String> item2 = [
    'Set reminder for your child’s  next dental visit',
  ];

  @override
  void initState() {
    super.initState();
  }

  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: ListView(
          children: [
            const CustomAppBar(),
            const Center(
              child: Text(
                'Dental Visit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            Image.asset('assets/firsteeth.png'),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'When Should Your Baby Visit the Dentist?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, letterSpacing: 1),
              ),
            ),
            Container(
              height: 100,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(225, 222, 231, 246)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 140,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Within 6 months',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            'of his or her first baby tooth',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset('assets/firsttooth.png'),
                  const SizedBox(
                    width: 140,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No later than ',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 10),
                          ),
                          Text(
                            'Age 1',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Healthy Baby teeth Support Healthy Development',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Image.asset(
                    'assets/chew.jpg',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Flexible(
                      child: Text(
                    'Help kids chew properly so they get nutrients',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/abc.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Flexible(
                      child: Text(
                    'Support healthy speech development',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/teethbaby.jpg',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Flexible(
                      child: Text(
                    'Save space for adult teeth to grow',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(28.0),
              child: Text(
                'When Should Your Baby Visit the Dentist?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, letterSpacing: 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: item1.length,
                itemBuilder: (BuildContext context, int index) {
                  return Box(
                    text: item1[index],
                    flutterTts: flutterTts,
                    colour: AppColors.primaryColor,
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Early Care Is an Investment in Your Child’s Health',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reduce the risk of painful tooth decay',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Image.asset(
                        'assets/badteeth.png',
                        width: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/Exclamation.png',
                      width: 45,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Catch oral health problems in their early stages',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Help your child get comfortable with dental care',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Image.asset(
                        'assets/DentistCheck.png',
                        width: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Exclamation.png',
                    width: 45,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Flexible(
                    child: Text(
                      'Visit dentist every six months or as recommended by the dentist',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Box(
                text: 'Set reminder for your child’s  next dental visit',
                flutterTts: flutterTts,
                colour: AppColors.primaryColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.lightblue),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Reminder(),
                          ));
                    },
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: AppColors.black,
                      size: 26,
                    ),
                    label: const Text(
                      'Set Reminder',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )),
              ],
            ),
            const BottomFooter(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
