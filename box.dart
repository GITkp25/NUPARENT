import 'package:flutter/material.dart';
import 'package:nu_parent/main.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BoxList extends StatefulWidget {
  final List<Map<String, dynamic>> dentalVList;

  const BoxList({
    Key? key,
    required this.dentalVList,
  }) : super(key: key);

  @override
  State<BoxList> createState() => _BoxListState();
}

class _BoxListState extends State<BoxList> {
  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.dentalVList.map((map) {
        final text = map['text'] as String;
        return Box(flutterTts: flutterTts, text: text);
      }).toList(),
    );
  }
}

class Box extends StatefulWidget {
  final FlutterTts flutterTts;
  final String text;
  final String title;
  final Color colour;

  const Box({
    Key? key,
    required this.flutterTts,
    required this.text,
    this.title = '',
    this.colour =
        AppColors.primaryColor, // Use the hexadecimal value of your color
  }) : super(key: key);

  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  bool isPlaying = false;

  Future speak(String stext) async {
    if (isPlaying) {
      widget.flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      await widget.flutterTts.setLanguage("en-US");
      await widget.flutterTts.speak(stext);
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightblue,
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
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.title != '')
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      Text(
                        widget.text,
                        style: TextStyle(
                            color: widget.colour,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w600,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (widget.title == '') {
                    speak(widget.text);
                  } else {
                    speak("${widget.title}. ${widget.text}");
                  }
                },
                icon: Icon(
                    isPlaying
                        ? Icons.stop_circle_rounded
                        : Icons.volume_up_rounded,
                    color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
