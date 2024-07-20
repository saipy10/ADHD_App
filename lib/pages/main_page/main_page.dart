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
  int breatheTime = 4,
      exerciseTimeMin = 5,
      exerciseTimeSec = 4,
      otm = 5,
      ots = 4;
  int phase = 0;
  String message = "Start";
  double currentPosi = 0, factor = 165 / 304;

  // Update the message and phase based on the current state
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

  // Start the timer and update exercise time and message accordingly
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (exerciseTimeSec > 0) {
        setState(() {
          exerciseTimeSec--;
          messageToShow();
          if (exerciseTimeSec > 0 || exerciseTimeMin > 0) {
            currentPosi = currentPosi + factor;
          }
        });
      } else if (exerciseTimeMin == 0 && exerciseTimeSec == 0) {
        setState(() => message = "Well Done!");
      } else {
        setState(() {
          exerciseTimeMin--;
          exerciseTimeSec = 59;
          messageToShow();
          if (exerciseTimeSec > 0 || exerciseTimeMin > 0) {
            currentPosi = currentPosi + factor;
          }
        });
      }
    });
  }

  // Stop the timer
  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    bool cond = (exerciseTimeMin == 0 && exerciseTimeSec == 0);

    // Widget to display the stress ball position and labels
    Widget stressBallLocatorWidgets() {
      return SizedBox(
        height: 250,
        width: 400,
        child: Stack(children: [
          Positioned(
            top: 150,
            child: Text(
              "PAST",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
          ),
          Positioned(
            top: 210,
            left: 160,
            child: Text(
              "PRESENT",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: 1,
            child: Text(
              "FUTURE",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 192,
            child: RotatedBox(
              quarterTurns: -1,
              child: Text(
                "STRESS",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
          ),
          Positioned(
            top: currentPosi,
            left: 192,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: cond ? Colors.green : Colors.yellow,
            ),
          ),
          Positioned(
            top: ((exerciseTimeMin * 60 + exerciseTimeSec) <=
                    ((otm * 60 + ots) / 2).floor())
                ? cond
                    ? currentPosi
                    : 100
                : 60,
            left: ((exerciseTimeMin * 60 + exerciseTimeSec) <=
                    ((otm * 60 + ots) / 2).floor())
                ? cond
                    ? 192
                    : 120
                : 10,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: cond ? Colors.green : Colors.red,
            ),
          ),
          Positioned(
            top: ((exerciseTimeMin * 60 + exerciseTimeSec) <=
                    (otm * 60 + ots) / 2)
                ? cond
                    ? currentPosi
                    : 100
                : 60,
            left: ((exerciseTimeMin * 60 + exerciseTimeSec) <=
                    (otm * 60 + ots) / 2)
                ? cond
                    ? 192
                    : 250
                : 360,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: cond ? Colors.green : Colors.blue,
            ),
          ),
        ]),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(209, 255, 215, 1),
                Color.fromRGBO(218, 255, 225, 1),
                Color.fromRGBO(227, 255, 235, 1),
                Color.fromRGBO(236, 255, 245, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
          child: Column(
            children: [
              // Mindfulness Breathing title
              const Text(
                "Mindfulness Breathing",
                style: TextStyle(
                  fontSize: 20.25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Breathe Timer display
              Text(
                "$breatheTime",
                style: const TextStyle(
                  fontSize: 140.25,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(12, 155, 0, 1),
                ),
              ),

              // Current breathing phase message
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
                      if (playOrPause && !cond) {
                        playOrPause = false;
                        stopTimer();
                      } else if (!cond) {
                        playOrPause = true;
                        startTimer();
                      } else {
                        playOrPause = false;
                        exerciseTimeMin = 5;
                        exerciseTimeSec = 4;
                        currentPosi = 0;
                        message = "Start";
                        stopTimer();
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: const Color.fromRGBO(217, 217, 217, 1),
                    ),
                    child: playOrPause && !cond
                        ? const Icon(
                            Icons.pause,
                            size: 32,
                            color: Color.fromRGBO(102, 102, 102, 1),
                          )
                        : cond
                            ? const Icon(
                                Icons.replay,
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

              // Display the total exercise time
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

              // Divider to separate sections
              const Divider(
                indent: 50,
                endIndent: 50,
              ),

              // Stress diagram and ball locator
              const StressDiagram(),
              stressBallLocatorWidgets(),
            ],
          ),
        ),
      ),
    );
  }
}
