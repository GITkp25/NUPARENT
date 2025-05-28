import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final Color color;

  WavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 3, size.height * 0.75, size.width / 2, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 2 / 3, size.height * 0.25, size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => color != oldDelegate.color;
}

class WaveBackground extends StatelessWidget {
  final Color color;

  const WaveBackground({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WavePainter(color),
      size: const Size(500, 500),
    );
  }
}
