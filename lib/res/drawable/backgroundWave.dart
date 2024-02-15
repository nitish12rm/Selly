import 'package:flutter/material.dart';

class BackgroundWave extends StatelessWidget {
  final double height;
   Color colors;
   BackgroundWave({Key? key, required this.height, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipPath(
          // clipper: BackgroundWaveClipper(),
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: height,
              decoration:  BoxDecoration(
              //     gradient: LinearGradient(
              //   colors: [
              //     Color.fromRGBO(58, 120, 255, 1),
              //     Color.fromRGBO(74, 67, 236, 1)
              //   ],
              // ),
                color: colors,
              ),
            ),
          )),
    );
  }
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    const minSize = 140.0;

    // when h = max = 280
    // h = 280, p1 = 210, p1Diff = 70
    // when h = min = 140
    // h = 140, p1 = 140, p1Diff = 0
    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();
    path.lineTo(0.0, size.height - p1Diff);

    final controlPoint = Offset(size.width , size.height);
    final endPoint = Offset(size.width, minSize);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper oldClipper) => oldClipper != this;
}
