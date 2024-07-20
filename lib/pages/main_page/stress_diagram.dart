import 'package:flutter/material.dart';

class StressDiagram extends StatefulWidget {
  const StressDiagram({super.key});

  @override
  State<StressDiagram> createState() => _StressDiagramState();
}

class _StressDiagramState extends State<StressDiagram> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurveCustomPainter(),
    );
  }
}

class CurveCustomPainter extends CustomPainter {
  double pt = 0.75;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint objects for different styles and colors
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.black;

    // Define points for the first curve

    var points1 = [
      const Offset(75 - 315, 300 - 50),
      const Offset(200 - 315, 300 - 50),
      const Offset(265 - 315, 275 - 50),
      const Offset(325 - 315, 225 - 50),
      const Offset(365 - 315, 175 - 50),
      const Offset(430 - 315, 125 - 50),
      const Offset(555 - 315, 125 - 50),
    ];

    // Draw blue circle at a specific point on the first curve
    // canvas.drawCircle(Offset(450, 135), 15, paint1);

    // Define points for the second curve
    var points2 = [
      const Offset(75 - 315, 125 - 50),
      const Offset(200 - 315, 125 - 50),
      const Offset(265 - 315, 175 - 50),
      const Offset(325 - 315, 225 - 50),
      const Offset(365 - 315, 275 - 50),
      const Offset(430 - 315, 300 - 50),
      const Offset(555 - 315, 300 - 50),
    ];

    // Draw red circle at a specific point on the second curve
    // canvas.drawCircle(Offset(210, 135), 15, paint2);

    // Paths for the curves
    var path1 = Path();
    var path2 = Path();

    // Move to the starting points of the curves
    path1.moveTo(points1[0].dx, points1[0].dy);
    path2.moveTo(points2[0].dx, points2[0].dy);

    // Create quadratic bezier curves for both sets of points
    for (var i = 1; i < points1.length - 2; i++) {
      var xc = (points1[i].dx + points1[i + 1].dx) / 2;
      var xy = (points1[i].dy + points1[i + 1].dy) / 2;

      path1.quadraticBezierTo(points1[i].dx, points1[i].dy, xc, xy);
    }

    for (var i = 1; i < points2.length - 2; i++) {
      var xc = (points2[i].dx + points2[i + 1].dx) / 2;
      var xy = (points2[i].dy + points2[i + 1].dy) / 2;

      path2.quadraticBezierTo(points2[i].dx, points2[i].dy, xc, xy);
    }

    // Complete the curves by drawing the last segment
    path1.quadraticBezierTo(
      points1[points1.length - 2].dx,
      points1[points1.length - 2].dy,
      points1[points1.length - 1].dx,
      points1[points1.length - 1].dy,
    );

    path2.quadraticBezierTo(
      points2[points2.length - 2].dx,
      points2[points2.length - 2].dy,
      points2[points2.length - 1].dx,
      points2[points2.length - 1].dy,
    );

    // Draw the paths on the canvas
    canvas.drawPath(path1, paint..color = Colors.grey);
    canvas.drawPath(path2, paint..color = Colors.grey);

    // Draw a vertical line and yellow circle
    canvas.drawLine(
        const Offset(8, 10), const Offset(8, 280), paint..color = Colors.grey);
    // canvas.drawCircle(const Offset(250, 25), 15, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Return true if the painter needs to repaint
    return false;
  }
}
