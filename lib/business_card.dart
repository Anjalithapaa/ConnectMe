import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String organization;
  final String title;

  BusinessCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.organization,
    required this.title,
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
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.2), // Adjust the gap at the top
                  Center(
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.15,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.14,
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Extra space below avatar

                  // Moved the name's portion below the blue background
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person,
                                color: Colors.black, size: 24),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                name.isNotEmpty ? name : 'Your Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  letterSpacing: 1.15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 20), // Increased spacing between rows
                      ],
                    ),
                  ),

                  // Other rows for email, phone, organization, title
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.black, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          email.isNotEmpty ? email : 'Your Email',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.black, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          phone.isNotEmpty ? phone : 'Your Phone',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.corporate_fare,
                          color: Colors.black, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          organization.isNotEmpty
                              ? organization
                              : 'Your Organization',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.work, color: Colors.black, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title.isNotEmpty ? title : 'Your Title',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
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
      colors: [Color.fromARGB(255, 3, 101, 146), Colors.blueAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    var path = Path();
    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.48, size.height * 0.38, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
