import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:lottie/lottie.dart';
import 'package:nu_parent/TimerSingleton.dart';
import 'package:nu_parent/main.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _check = true;
  String countDown = "";
  TimerSingleton timer = TimerSingleton();

  Future<void> showLottieAnimationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 280,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Lottie.asset(
                    'assets/confetti.json',
                    width: 240,
                    height: 240,
                    repeat: true,
                    animate: true,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Lottie.asset(
                    'assets/teeth.json',
                    width: 240,
                    height: 240,
                    repeat: true,
                    animate: true,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                stopBeepSound(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void notify() async {
    if (timer.time == '0:00:00' && !timer.soundPlayed) {
      timer.soundPlayed = true;
      await startBeepSound();
      showLottieAnimationDialog(context);
      setState(() {
        timer.showBottomBar = false; // Hide the bottom bar when time is 0:00:00
      });
    }
  }

  Future<void> startBeepSound() async {
    await FlutterRingtonePlayer.playAlarm();
  }

  void stopBeepSound(BuildContext context) {
    FlutterRingtonePlayer.stop();

    timer.soundPlayed = false;
    timer.time = "0:00:00";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    timer.timerStream.listen((event) {
      setState(() {
        countDown = event;
        notify();
      });
    });
    return timer.showBottomBar
        ? _buildBottomBar()
        : const SizedBox(); // Conditional rendering of bottom bar
  }

Widget _buildBottomBar() {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 90, 90, 90).withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            // Stop button logic
            timer.stopTimer();
            setState(() {
              timer.showBottomBar = false; // Hide the bottom bar
            });
          },
          icon: const Icon(
            Icons.stop,
            size: 40,
            color: AppColors.primaryColor,
          ),
        ),
        Lottie.asset(
          'assets/TeethBrushing.json',
          width: 70,
          height: 70,
          repeat: true,
          animate: true,
        ),
        Text(
          countDown,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                _check ? timer.pauseTimer() : timer.resumeTimer();
                setState(() {
                  _check = !_check;
                });
              },
              icon: Icon(
                _check ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 40,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        )
      ],
    ),
  );
}

}
