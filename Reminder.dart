// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nu_parent/Components/bottom_bar.dart';
import 'package:nu_parent/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:nu_parent/local_notification_service.dart';
import 'package:nu_parent/notification_details.dart';

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  late String userId;
  late FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    listenToNotificationStream();
    final user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    _loadTimesFromFirestore();
    _loadDateFromFirestore();
  }

  void listenToNotificationStream() {
    LocalNotificationService.streamController.stream.listen(
      (notificationResponse) {
        log(notificationResponse.id!.toString());
        log(notificationResponse.payload!.toString());
        //logic to get product from database.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDetailsScreen(
              response: notificationResponse,
            ),
          ),
        );
      },
    );
  }

  DateTime? _toothbrushReplacementDate;
  DateTime? _dentalVisitDate;

  Future<void> _selectToothbrushReplacementDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toothbrushReplacementDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _toothbrushReplacementDate) {
      setState(() {
        _toothbrushReplacementDate = picked;
        _updateDateInFirestore('toothbrushReplacement', picked);
      });
    }
    final DateTime replacementDate = picked!.add(const Duration(days: 90));

    final DateTime notificationDateTime = DateTime(replacementDate.year, replacementDate.month, replacementDate.day, 9, 0);

    LocalNotificationService.scheduleToothbrushReplacementNotification(notificationDateTime);
  }

  Future<void> _selectDentalVisitDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dentalVisitDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _dentalVisitDate) {
      setState(() {
        _dentalVisitDate = picked;
        _updateDateInFirestore('dentalVisitDate', picked);
      });
    }
    final DateTime notificationDateTime = DateTime(picked!.year, picked.month, picked.day, 9, 0);


    LocalNotificationService.scheduleDentalVisitNotification(notificationDateTime);
  }

  Future<void> _updateDateInFirestore(String dateType, DateTime date) async {
    try {
      await firestore.collection(dateType).doc(userId).set({
        'date': date,
        'user': userId,
      });
    } catch (e) {
      print('Error updating date in Firestore: $e');
    }
  }

  TimeOfDay _selectedMorningTime =
      const TimeOfDay(hour: 8, minute: 0); // Default morning time
  TimeOfDay _selectedEveningTime =
      const TimeOfDay(hour: 20, minute: 0); // Default evening time

  Future<void> _selectMorningTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedMorningTime,
    );
    if (picked != null && picked != _selectedMorningTime) {
      setState(() {
        _selectedMorningTime = picked;
      });
       
      _updateTimeInFirestore('morning', picked);
      _scheduleDailyMorningNotification(picked);
    }
  }

  void _scheduleDailyMorningNotification(TimeOfDay pickedTime) async {
  final now = DateTime.now();
  final selectedTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
  LocalNotificationService.showDailyMorningNotification(selectedTime);
}



  Future<void> _selectEveningTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEveningTime,
    );
    if (picked != null && picked != _selectedEveningTime) {
      setState(() {
        _selectedEveningTime = picked;
      });
      _updateTimeInFirestore('evening', picked);
       _scheduleDailyEveningNotification(picked);
    }
  }

   void _scheduleDailyEveningNotification(TimeOfDay pickedTime) async {
  final now = DateTime.now();
  final selectedTime = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
  LocalNotificationService.showDailyEveningNotification(selectedTime);
}


  Future<void> _updateTimeInFirestore(String timeType, TimeOfDay time) async {
    try {
      await firestore.collection(timeType).doc(userId).set({
        'hour': time.hour,
        'minute': time.minute,
        'user': userId,
      });
    } catch (e) {
      print('Error updating time in Firestore: $e');
    }
  }

  Future<void> _loadDateFromFirestore() async {
    try {
      final dentalSnapshot =
          await firestore.collection('dentalVisitDate').doc(userId).get();
      final brushSnapshot =
          await firestore.collection('toothbrushReplacement').doc(userId).get();

      if (dentalSnapshot.exists) {
        final dentalData = dentalSnapshot.data() as Map<String, dynamic>;
        final Timestamp dentalTimestamp = dentalData['date'];
        setState(() {
          _dentalVisitDate = dentalTimestamp.toDate();
        });
      }

      if (brushSnapshot.exists) {
        final brushData = brushSnapshot.data() as Map<String, dynamic>;
        final Timestamp brushTimestamp = brushData['date'];
        setState(() {
          _toothbrushReplacementDate = brushTimestamp.toDate();
        });
      }
    } catch (e) {
      print('Error loading Date from Firestore: $e');
    }
  }

  // Load the user's times from Firestore
  Future<void> _loadTimesFromFirestore() async {
    try {
      final morningSnapshot =
          await firestore.collection('morning').doc(userId).get();
      final eveningSnapshot =
          await firestore.collection('evening').doc(userId).get();

      if (morningSnapshot.exists) {
        final morningData = morningSnapshot.data() as Map<String, dynamic>;
        final hour = morningData['hour'] as int;
        final minute = morningData['minute'] as int;
        setState(() {
          _selectedMorningTime = TimeOfDay(hour: hour, minute: minute);
        });
      }

      if (eveningSnapshot.exists) {
        final eveningData = eveningSnapshot.data() as Map<String, dynamic>;
        final hour = eveningData['hour'] as int;
        final minute = eveningData['minute'] as int;
        setState(() {
          _selectedEveningTime = TimeOfDay(hour: hour, minute: minute);
        });
      }
    } catch (e) {
      print('Error loading times from Firestore: $e');
    }
  }

  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Vector-1.png'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Reminder',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Image.asset(
                        'assets/reminder.png',
                        width: 150,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(255, 220, 231, 253),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          const Text(
                            'Brushing',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: _selectMorningTime,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Morning',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '${_selectedMorningTime.format(context)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: _selectEveningTime,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Evening',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '${_selectedEveningTime.format(context)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Card(
                      text:
                          "Brush your child’s teeth twice a day – in the morning and at night before bed"),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _selectToothbrushReplacementDate,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 220, 231, 253),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            const Text(
                              'Toothbrush replacement',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _toothbrushReplacementDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(_toothbrushReplacementDate!)
                                        : 'Select Date',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today_outlined),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Card(
                    text: "Replace your child’s toothbrush every 3 months ",
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _selectDentalVisitDate,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 220, 231, 253),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            const Text(
                              'Dental Visits',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _dentalVisitDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(_dentalVisitDate!)
                                        : 'Select Date',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today_outlined),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Card(
                    text:
                        "Visit a dentist before turning one year old, or as soon as their first teeth appear.",
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Card extends StatefulWidget {
  final String text;
  const Card({super.key, required this.text});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.tilesecondaryblue,
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w600),
      ),
    );
  }
}
