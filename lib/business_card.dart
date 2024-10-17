import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String photoUrl;

  BusinessCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: CustomPaint(
            painter: CurvePainter(),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.09,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.08,
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  name.isNotEmpty ? name : 'Your Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.15,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  email.isNotEmpty ? email : 'Your Email',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  phone.isNotEmpty ? phone : 'Your Phone',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.1,
                  endIndent: MediaQuery.of(context).size.width * 0.1,
                  color: Colors.grey.shade400,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.shader = LinearGradient(
      colors: [Color(0xff8160c7), Color(0xff8f77dc), Color(0xff8f67bc)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    
    var path = Path();
    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.48, size.height * 0.38, size.width, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.38, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
