import 'dart:async';

import 'package:adhd_app/pages/main_page/stress_diagram.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Timer? timer;
  bool playOrPause = false;
  int breatheTime = 4, exerciseTimeMin = 5, exerciseTimeSec = 04;
  int phase = 0;
  String message = "Start";

  void messageToShow() {
    switch (phase) {
      case 0:
        message = "Inhale...";
        if (breatheTime > 0) breatheTime--;
        if (breatheTime == 0) {
          phase = 1;
          breatheTime = 7;
          message = "Hold...";
        }

        break;
      case 1:
        message = "Hold...";
        if (breatheTime > 0) breatheTime--;
        if (breatheTime == 0) {
          phase = 2;
          breatheTime = 8;
          message = "Exhale...";
        }
        break;
      case 2:
        message = "Exhale...";
        if (breatheTime > 0) breatheTime--;
        if (breatheTime == 0) {
          phase = 0;
          breatheTime = 4;
          message = "Inhale...";
        }
        break;
      default:
        message = "Start";
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (exerciseTimeSec > 0) {
        setState(() {
          exerciseTimeSec--;
          messageToShow();
        });
      } else if (exerciseTimeMin == 0 && exerciseTimeSec == 0) {
        setState(() => message = "Well Done!");
      } else {
        setState(() {
          exerciseTimeMin--;
          exerciseTimeSec = 59;
          messageToShow();
        });
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            // Mindfulness Breathing
            const Text(
              "Mindfulness Breathing",
              style: TextStyle(
                fontSize: 20.25,
                fontWeight: FontWeight.w700,
              ),
            ),

            // Breathe Timer
            Text(
              "$breatheTime",
              style: const TextStyle(
                fontSize: 140.25,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(12, 155, 0, 1),
              ),
            ),

            // Breathe Text
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28.25,
                color: Color.fromRGBO(12, 155, 0, 1),
              ),
            ),

            // Play and Pause button
            SizedBox(
              height: 54,
              width: 54,
              child: InkWell(
                borderRadius: BorderRadius.circular(26),
                onTap: () {
                  setState(() {
                    if (playOrPause) {
                      playOrPause = false;
                      stopTimer();
                    } else {
                      playOrPause = true;
                      startTimer();
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: const Color.fromRGBO(217, 217, 217, 1),
                  ),
                  child: playOrPause
                      ? const Icon(
                          Icons.pause,
                          size: 32,
                          color: Color.fromRGBO(102, 102, 102, 1),
                        )
                      : const Icon(
                          Icons.play_arrow,
                          size: 32,
                          color: Color.fromRGBO(102, 102, 102, 1),
                        ),
                ),
              ),
            ),

            // Total exercise time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$exerciseTimeMin",
                  style: const TextStyle(
                    fontSize: 28.25,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(125, 125, 125, 1),
                  ),
                ),
                const Text(
                  " mins ",
                  style: TextStyle(fontSize: 18.25),
                ),
                Text(
                  "$exerciseTimeSec",
                  style: const TextStyle(
                    fontSize: 28.25,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(125, 125, 125, 1),
                  ),
                ),
                const Text(
                  " secs ",
                  style: TextStyle(fontSize: 18.25),
                ),
              ],
            ),

            // Divider
            Divider(
              indent: 50,
              endIndent: 50,
            ),

            // Stress diagram
            StressDiagram(),
          ],
        ),
      ),
    );
  }
}
