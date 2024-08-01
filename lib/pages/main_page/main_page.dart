import 'dart:async';
import 'dart:math';
import 'dart:ui' as UI;
import 'package:adhd_app/pages/main_page/stress_diagram.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;
  final double radius = 150.0;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 19), // Total duration is 19 seconds
    );

    // Define a custom curve with smooth transitions between segments
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: _SmoothThreeSegmentCurve(),
    );

    _animation = Tween<double>(begin: -pi / 2, end: 2 * pi - pi / 2)
        .animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    // Start the animation
    // _controller.repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
      if (_isAnimating) {
        _controller.forward();
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool cond = (exerciseTimeMin == 0 && exerciseTimeSec == 0);

    // Calculate the current angle based on the animation value
    double angle = _animation.value;

    double x = radius * cos(angle);
    double y = radius * sin(angle);

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
                color: Colors.deepPurple[_isDark ? 300 : 900],
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
                color: Colors.deepPurple[_isDark ? 300 : 900],
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
                color: Colors.deepPurple[_isDark ? 300 : 900],
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
                  color: Colors.deepPurple[_isDark ? 300 : 900],
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
      backgroundColor:
          _isDark ? Color.fromRGBO(60, 30, 95, 1.0) : Colors.deepPurple[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            _isDark = !_isDark;
          })
        },
        child: _isDark
            ? Icon(
                Icons.sunny,
                color: Colors.yellow[200],
              )
            : Icon(
                Icons.dark_mode,
                color: Colors.blue[200],
              ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mindfulness Breathing title
            Text(
              "Mindfulness Breathing",
              style: TextStyle(
                fontSize: 20.25,
                fontWeight: FontWeight.w700,
                color: _isDark ? Colors.purple[300] : Colors.purple[900],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (playOrPause && !cond) {
                    playOrPause = false;
                    _toggleAnimation();
                    stopTimer();
                  } else if (!cond) {
                    playOrPause = true;
                    _toggleAnimation();
                    startTimer();
                  } else {
                    playOrPause = false;
                    exerciseTimeMin = 5;
                    exerciseTimeSec = 4;
                    currentPosi = 0;
                    message = "Start";
                    _toggleAnimation();
                    stopTimer();
                  }
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 280,
                    width: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          //rgb(134, 178, 240)
                          Color.fromRGBO(134, 178, 240, 1),
                          //rgb(136, 176, 246)
                          Color.fromRGBO(136, 176, 246, 1),
                          //rgb(133, 147, 244)
                          Color.fromRGBO(133, 147, 244, 1),
                          //rgb(132, 121, 243)
                          Color.fromRGBO(132, 121, 243, 1),
                          //rgb(132, 111, 242)
                          Color.fromRGBO(132, 111, 242, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // part time
                        Text(
                          "$breatheTime",
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontSize: 100,
                          ),
                        ),
                        // instruction
                        Text(
                          "$message",
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          "${exerciseTimeMin} min ${exerciseTimeSec} secs",
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(150),
                        border: Border.all(color: Colors.deepPurple, width: 5)),
                  ),
                  Positioned(
                    top: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey[600],
                    ),
                  ),
                  Positioned(
                    top: 224,
                    right: 20,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey[600],
                    ),
                  ),
                  Positioned(
                    top: 224,
                    left: 20,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey[600],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(x, y),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurple[_isDark ? 200 : 700],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 20,
                      child: playOrPause && !cond
                          ? const Icon(
                              Icons.pause,
                              size: 25,
                              color: Color.fromRGBO(102, 102, 102, 1),
                            )
                          : cond
                              ? const Icon(
                                  Icons.replay,
                                  size: 25,
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                )
                              : const Icon(
                                  Icons.play_arrow,
                                  size: 25,
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                ),
                    ),
                  ),
                ],
              ),
            ),

            // // Play and Pause button
            // SizedBox(
            //   height: 36,
            //   width: 36,
            //   child: InkWell(
            //     borderRadius: BorderRadius.circular(26),
            //     onTap: () {
            //       setState(() {
            //         if (playOrPause && !cond) {
            //           playOrPause = false;
            //           _toggleAnimation();
            //           stopTimer();
            //         } else if (!cond) {
            //           playOrPause = true;
            //           _toggleAnimation();
            //           startTimer();
            //         } else {
            //           playOrPause = false;
            //           exerciseTimeMin = 5;
            //           exerciseTimeSec = 4;
            //           currentPosi = 0;
            //           message = "Start";
            //           _toggleAnimation();
            //           stopTimer();
            //         }
            //       });
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(26),
            //         color: const Color.fromRGBO(217, 217, 217, 1),
            //       ),
            //       child: playOrPause && !cond
            //           ? const Icon(
            //               Icons.pause,
            //               size: 32,
            //               color: Color.fromRGBO(102, 102, 102, 1),
            //             )
            //           : cond
            //               ? const Icon(
            //                   Icons.replay,
            //                   size: 32,
            //                   color: Color.fromRGBO(102, 102, 102, 1),
            //                 )
            //               : const Icon(
            //                   Icons.play_arrow,
            //                   size: 32,
            //                   color: Color.fromRGBO(102, 102, 102, 1),
            //                 ),
            //     ),
            //   ),
            // ),

            // Divider to separate sections
            const Divider(
              indent: 50,
              endIndent: 50,
              color: Colors.deepPurple,
            ),

            // Stress diagram and ball locator
            const StressDiagram(),
            stressBallLocatorWidgets(),
          ],
        ),
      ),
    );
  }
}

class AtomPaint extends CustomPainter {
  AtomPaint({
    required this.value,
  });

  final double value;

  Paint _axisPaint = Paint()
    ..color = Colors.deepPurple
    ..strokeWidth = 8.0
    ..style = PaintingStyle.stroke;

  final arcsRect1 = Rect.fromLTWH(-10, -176, 20, 20);
  final arcsRect2 = Rect.fromLTWH(-153, 75, 20, 20);
  final arcsRect3 = Rect.fromLTWH(133, 75, 20, 20);

  @override
  void paint(Canvas canvas, Size size) {
    drawAxis(value, canvas, 170, Paint()..color = Colors.grey);
    canvas.drawArc(arcsRect1, 0.0, pi, true, Paint()..color = Colors.grey);
    canvas.drawArc(
        arcsRect2, pi / 3 + pi, pi, true, Paint()..color = Colors.grey);
    canvas.drawArc(
        arcsRect3, -(pi / 3 + pi), pi, true, Paint()..color = Colors.grey);
  }

  drawAxis(double value, Canvas canvas, double radius, Paint paint) {
    canvas.save();
    canvas.rotate(-pi / 2);
    var firstAxis = getCirclePath(radius);
    canvas.drawPath(firstAxis, _axisPaint);
    UI.PathMetrics pathMetrics = firstAxis.computeMetrics();
    for (UI.PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;
        canvas.drawCircle(offset, 12.0, paint);
      } catch (e) {}
    }
    canvas.restore();
  }

  Path getCirclePath(double radius) =>
      Path()..addOval(Rect.fromCircle(center: Offset(0, 0), radius: radius));

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// Custom curve to handle smooth transitions between different speeds
class _SmoothThreeSegmentCurve extends Curve {
  @override
  double transform(double t) {
    if (t < 4 / 19) {
      // First segment (0 to 4 seconds)
      double segmentT = t / (4 / 19);
      return segmentT * (1 / 3);
    } else if (t < 11 / 19) {
      // Second segment (4 to 11 seconds)
      double segmentT = (t - 4 / 19) / ((11 / 19) - (4 / 19));
      return (1 / 3) + segmentT * (1 / 3);
    } else {
      // Third segment (11 to 19 seconds)
      double segmentT = (t - 11 / 19) / ((19 / 19) - (11 / 19));
      return (2 / 3) + segmentT * (1 / 3);
    }
  }
}
