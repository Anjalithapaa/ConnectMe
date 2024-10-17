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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 40.0), // Added padding
              child: Column(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width *
                        0.15, // Increased size
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width *
                          0.14, // Increased size
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.person,
                          color: Colors.black, size: 24), // Icon for name
                      const SizedBox(width: 8), // Spacing between icon and text
                      Expanded(
                        child: Text(
                          name.isNotEmpty ? name : 'Your Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                26, // Increased font size for better visibility
                            letterSpacing: 1.15,
                            color: Colors.black, // Changed to black
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.email,
                          color: Colors.black, size: 24), // Icon for email
                      const SizedBox(width: 8), // Spacing between icon and text
                      Expanded(
                        child: Text(
                          email.isNotEmpty ? email : 'Your Email',
                          style: TextStyle(
                            color: Colors.black, // Changed to black
                            fontSize: 18, // Increased font size for email
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone,
                          color: Colors.black,
                          size: 24), // Icon for phone number
                      const SizedBox(width: 8), // Spacing between icon and text
                      Expanded(
                        child: Text(
                          phone.isNotEmpty ? phone : 'Your Phone',
                          style: TextStyle(
                            color: Colors.black, // Changed to black
                            fontSize: 18, // Increased font size for phone
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
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
      colors: [
        Color.fromARGB(255, 3, 101, 146),
        Colors.blueAccent
      ], // Using your primary color
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
