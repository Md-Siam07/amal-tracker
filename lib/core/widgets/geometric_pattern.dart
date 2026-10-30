import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Tiled eight-point star (two overlapping squares), a classic Islamic motif.
class GeometricPatternPainter extends CustomPainter {
  GeometricPatternPainter({required this.color, this.cell = 56});

  final Color color;
  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final radius = cell * 0.36;

    var row = 0;
    for (double y = 0; y < size.height + cell; y += cell) {
      final shift = row.isOdd ? cell / 2 : 0.0;
      for (double x = -cell; x < size.width + cell; x += cell) {
        _drawStar(canvas, Offset(x + shift, y), radius, paint);
      }
      row++;
    }
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (var k = 0; k < 2; k++) {
      final rotation = k * math.pi / 4;
      for (var i = 0; i < 4; i++) {
        final a = rotation + i * math.pi / 2;
        final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GeometricPatternPainter old) =>
      old.color != color || old.cell != cell;
}
