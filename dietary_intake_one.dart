// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/Components/box.dart';
import 'package:nu_parent/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DietaryIntakeOne extends StatefulWidget {
  const DietaryIntakeOne({super.key});

  @override
  State<DietaryIntakeOne> createState() => _DietaryIntakeOneState();
}

class _DietaryIntakeOneState extends State<DietaryIntakeOne> {
  String? ageId;

  FlutterTts flutterTts = FlutterTts();
  late Future<List<Map<String, dynamic>>> _dietaryIntake;
  @override
  void initState() {
    super.initState();
    _dietaryIntake = _getData();
  }

  Future<List<Map<String, dynamic>>> _getData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collectionRef = firestore.collection('ageGroups');
      QuerySnapshot querySnapshot =
          await collectionRef.where('age', isEqualTo: '1 - 2').get();
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first (and only) document
        DocumentSnapshot doc = querySnapshot.docs[0];
        ageId = doc.id;
      } else {
        print('No document found with age = 1 - 2');
      }

      // Use the extracted age value to query the "oralHygiene" collection
      QuerySnapshot dietary = await FirebaseFirestore.instance
          .collection('dietaryintake')
          .where('age', isEqualTo: ageId)
          .get();

      // Process each document in the "oralHygiene" collection
      List<Map<String, dynamic>> data = dietary.docs
          .map((DocumentSnapshot document) =>
              document.data() as Map<String, dynamic>)
          .toList();

      return data;
    } catch (e) {
      print("Error getting data: $e");
      return [];
    }
  }

  Future speak(String stext) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(stext);
  }

  bool check = false;
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
        child: ListView(
          children: [
            const CustomAppBar(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                'First and Second Year of Age',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.darkblue,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              )),
            ),
            Image.asset('assets/FamilyEating.jpg'),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _dietaryIntake,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While data is being fetched, show a custom loading layout
                    return Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Logo.png', // Replace with the path to your logo
                            height: 100,
                          ),
                          const SizedBox(height: 16),
                          const CircularProgressIndicator(),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // If an error occurs during data fetching, show an error message
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // If no data is available, show a message indicating no data
                    return const Text('No dental visit data available');
                  } else {
                    // If data is available, create Box widgets with custom layout
                    final dataList = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        final text =
                            dataList[index]['dietaryintake'] as String? ??
                                'Default Text';
                        return Column(
                          children: [
                            Box(
                              text: text,
                              flutterTts: flutterTts,
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 123, 149, 193),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2.0,
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Flexible(
                        child: Column(
                          children: [
                            Text(
                              'Parenting plays an important role in the transition from milk to solid foods.',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Parents influence what the child likes or dislikes, the quality of diet, and overall weight status.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            speak(
                              'Parenting plays an important role in the transition from milk to solid foods. Parents influence what the child likes or dislikes, the quality of diet, and overall weight status.',
                            );
                          },
                          icon: const Icon(Icons.volume_up_rounded),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
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
