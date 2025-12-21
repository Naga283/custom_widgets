import 'package:flutter/material.dart';

class NbpWaveWidget extends StatelessWidget {
  const NbpWaveWidget({
    super.key,
    this.firstWaveHeight,
    this.secondWaveHeight,
    this.thirdWaveHeight,
    this.firstWaveColor,
    this.secondWaveColor,
    this.thirdWaveColor,
  });
  final double? firstWaveHeight;
  final double? secondWaveHeight;
  final double? thirdWaveHeight;
  final Color? firstWaveColor;
  final Color? secondWaveColor;
  final Color? thirdWaveColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // or whatever the actual visible wave height is
      child: OverflowBox(
        maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: firstWaveHeight ?? 250, // this can remain large
                color: firstWaveColor ?? Colors.amber,
              ),
            ),
            ClipPath(
              clipper: SecondWaveClipper(),
              child: Container(
                height: secondWaveHeight ?? 220,
                color: secondWaveColor ?? Colors.red,
              ),
            ),
            ClipPath(
              clipper: ThirdWaveClipper(),
              child: Container(
                height: thirdWaveHeight ?? 200,
                color: thirdWaveColor ?? Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height - 70);

    final firstControlPoint = Offset(size.width * 0.75, size.height - 20);
    final firstEndPoint = Offset(size.width * 0.55, size.height - 90);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.18, size.height - 220);
    final secondEndPoint = Offset(0, size.height - 140);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SecondWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height - 70);

    final firstControlPoint = Offset(size.width * 0.8, size.height);
    final firstEndPoint = Offset(size.width * 0.51, size.height - 90);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.2, size.height - 200);
    final secondEndPoint = Offset(0, size.height - 122);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ThirdWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height - 70);

    final firstControlPoint = Offset(size.width * 0.8, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height - 90);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.2, size.height - 190);
    final secondEndPoint = Offset(0, size.height - 115);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
