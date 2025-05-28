import 'package:flutter/material.dart';
import 'package:nu_parent/Components/appbar.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/Components/box.dart';
import 'package:nu_parent/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class OralHygieneBabies extends StatefulWidget {
  const OralHygieneBabies({super.key});

  @override
  State<OralHygieneBabies> createState() => _OralHygieneBabiesState();
}

class _OralHygieneBabiesState extends State<OralHygieneBabies> {
  String? ageId;

  FlutterTts flutterTts = FlutterTts();
  late Future<List<Map<String, dynamic>>> _OralHygiene;
  @override
  void initState() {
    super.initState();
    _OralHygiene = _getData();
  }

  Future<List<Map<String, dynamic>>> _getData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collectionRef = firestore.collection('ageGroups');
      QuerySnapshot querySnapshot =
          await collectionRef.where('age', isEqualTo: '0 - 3').get();
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first (and only) document
        DocumentSnapshot doc = querySnapshot.docs[0];
        ageId = doc.id;
        // doc.id will give you the document ID
        print('Document ID: ${doc.id}');
      } else {
        print('No document found with age = 0 - 3');
      }

      // Use the extracted age value to query the "oralHygiene" collection
      QuerySnapshot oralChildren = await FirebaseFirestore.instance
          .collection('oralHygiene')
          .where('age', isEqualTo: ageId)
          .get();

      // Process each document in the "oralHygiene" collection
      List<Map<String, dynamic>> data = oralChildren.docs
          .map((DocumentSnapshot document) =>
              document.data() as Map<String, dynamic>)
          .toList();

      return data;
    } catch (e) {
      print("Error getting data: $e");
      return [];
    }
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
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ListView(
            children: [
              const CustomAppBar(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  'Babies (0-3 years)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                )),
              ),
              Image.asset('assets/dentalcare.png'),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _OralHygiene,
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
                        itemCount: dataList.length +
                            1, // Add 1 for the additional image
                        itemBuilder: (context, index) {
                          if (index == 7) {
                            // Display the image after the first 7 items
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/WhiteSpots.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          } else if (index < 7) {
                            // Display the items from dataList for index < 7
                            final text =
                                dataList[index]['oralHygiene'] as String? ??
                                    'Default Text';
                            return Column(
                              children: [
                                Box(
                                  text: text,
                                  flutterTts: flutterTts,
                                ),
                              ],
                            );
                          } else {
                            // Display the items from dataList for index > 7
                            final dataIndex = index - 1;
                            final text =
                                dataList[dataIndex]['oralHygiene'] as String? ??
                                    'Default Text';
                            return Column(
                              children: [
                                Box(
                                  text: text,
                                  flutterTts: flutterTts,
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                'assets/childparent.png',
                height: 100,
              ),
              const SizedBox(
                height: 90,
              ),
            ],
          ),
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
