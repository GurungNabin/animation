import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HourGlass(),
    );
  }
}

class HourGlass extends StatefulWidget {
  const HourGlass({super.key});

  @override
  State<HourGlass> createState() => _HourGlassState();
}

class _HourGlassState extends State<HourGlass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sandAnimation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          })
          ..repeat();

    _sandAnimation =
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.95));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.6,
        heightFactor: 0.6,
        child: CustomPaint(
          child: Container(),
          foregroundPainter:
              HourGlassPainter(sandPercentage: _sandAnimation.value),
        ),
      ),
    );
  }
}

class HourGlassPainter extends CustomPainter {
  final double? sandPercentage;

  HourGlassPainter({this.sandPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = Offset(size.width / 2, size.height / 2);

    final hourGlassPath = Path()
      ..moveTo(center.dx - radius.dx - 10, 0.0)
      ..lineTo(center.dx + radius.dx + 10, 0.0)
      ..moveTo(-10, size.height)
      ..lineTo(center.dx + radius.dx + 10, size.height)
      ..moveTo(0.0, 0.0)
      ..lineTo(center.dx + radius.dx, 0.0)
      ..quadraticBezierTo(
          center.dx + radius.dx, radius.dy / 2, center.dx, center.dy)
      ..quadraticBezierTo(center.dx + radius.dx, (size.height + radius.dy) / 2,
          center.dx + radius.dx, size.height)
      // Mirroring the right side commands to draw the left side
      ..moveTo(center.dx - radius.dx, 0.0)
      ..lineTo(0.0, 0.0)
      ..quadraticBezierTo(
          center.dx - radius.dx, radius.dy / 2, center.dx, center.dy)
      ..quadraticBezierTo(center.dx - radius.dx, (size.height + radius.dy) / 2,
          center.dx - radius.dx, size.height);

    final upperSandPath = Path()
      ..addRect(
        Rect.fromLTRB(
          0.0,
          radius.dy * sandPercentage!,
          size.width,
          radius.dy,
        ),
      );
    canvas.drawPath(
        Path.combine(PathOperation.intersect, hourGlassPath, upperSandPath),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);

    final lowerSandPath = Path()
      ..addRect(
        Rect.fromLTRB(
          0.0,
          radius.dy * (1 - sandPercentage!) + center.dy,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
        Path.combine(PathOperation.intersect, hourGlassPath, lowerSandPath),
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);

    canvas.drawPath(
        hourGlassPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..color = Colors.white60);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is HourGlassPainter &&
      oldDelegate.sandPercentage != sandPercentage;
}
