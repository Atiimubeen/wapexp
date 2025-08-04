import 'package:flutter/material.dart';

class WavyBackground extends StatelessWidget {
  final Widget child;
  const WavyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background waves
        Positioned.fill(
          child: ClipPath(
            clipper: WavyClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade300, Colors.green.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        // Aapka page content
        SafeArea(child: child),
      ],
    );
  }
}

// Yeh class waves banati hai
class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.4); // Start point

    var firstControlPoint = Offset(size.width / 4, size.height * 0.5);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.4);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.3);
    var secondEndPoint = Offset(size.width, size.height * 0.4);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0); // End point
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
