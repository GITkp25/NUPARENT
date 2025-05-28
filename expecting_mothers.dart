// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/Components/box.dart';
import 'package:nu_parent/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ExpectingMother extends StatefulWidget {
  const ExpectingMother({super.key});

  @override
  State<ExpectingMother> createState() => _ExpectingMotherState();
}

class _ExpectingMotherState extends State<ExpectingMother> {
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
          await collectionRef.where('age', isEqualTo: 'Pregnant Mother').get();
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first (and only) document
        DocumentSnapshot doc = querySnapshot.docs[0];
        ageId = doc.id;
        // doc.id will give you the document ID
        print('Document ID: ${doc.id}');
      } else {
        print('No document found with age = 0 - 1');
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
      bottomNavigationBar: BottomBar(),
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
                'Expecting Mothers',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              )),
            ),
            Image.asset('assets/EatWell.png'),
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
