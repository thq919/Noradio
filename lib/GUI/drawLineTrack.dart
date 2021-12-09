import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {

  MyCustomPainter(Animation anim) : super(repaint: anim) {

  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-size.width, size.height / 2),
        Offset(size.width, size.height / 2), Paint().);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}