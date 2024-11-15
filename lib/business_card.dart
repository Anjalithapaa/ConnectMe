import 'dart:convert'; // Import for Base64 decoding
import 'dart:typed_data';
import 'package:connect_me/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'qrcode.dart';
import 'form_page.dart';
import 'dart:typed_data';
import 'dart:convert';  // For base64Decode

class BusinessCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String linkedIn;
  final String photoUrl; // This will now handle Base64-encoded image strings.
  final String organization;
  final String title;

  const BusinessCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.organization,
    required this.title,
    required this.linkedIn,
  });
  // Helper function to decode Base64 string
  ImageProvider? _getImageFromBase64(String base64String) {
    try {
      // Ensure the Base64 string is properly padded
      String formattedBase64 = base64String;
      while (formattedBase64.length % 4 != 0) {
        formattedBase64 += '=';
      }

      // Decode the Base64 string
      Uint8List imageBytes = base64Decode(formattedBase64);
      return MemoryImage(imageBytes);
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return null; // Return null if the image decoding fails
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final userData = await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AuthenticatedHomePage(
                  userName: userData['name'] ?? 'User',
                ),
              ),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 3, 101, 146),
        elevation: 0,
      ),
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
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Center(
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.15,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.14,

                        backgroundImage: MemoryImage(base64Decode(photoUrl)),

                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  letterSpacing: 1.15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.black, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _launchUrl('mailto:$email'),
                          child: Text(
                            email.isNotEmpty ? email : 'Your Email',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                            ),
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
                        child: GestureDetector(
                          onTap: () => _launchUrl('tel:$phone'),
                          child: Text(
                            phone.isNotEmpty ? phone : 'Your Phone',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                            ),
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
                          style: const TextStyle(
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
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.linkedin,
                            color: Colors.blue, size: 30),
                        onPressed: () => _launchUrl(linkedIn),
                      ),
                    ],
                  ),
                  Divider(
                    indent: MediaQuery.of(context).size.width * 0.1,
                    endIndent: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.grey.shade400,
                    thickness: 1,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRCodeScreen(
                                  name: name,
                                  email: email,
                                  phone: phone,
                                  linkedIn: linkedIn,
                                  photoUrl: photoUrl,
                                  organization: organization,
                                  title: title,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red,
                            elevation: 0,
                          ),
                          child: const Text('Share'),
                        ),
                        const SizedBox(width: 16), // Space between buttons
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red,
                            elevation: 0,
                          ),
                          child: const Text("Edit"),
                        ),
                      ],
                    ),
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
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color.fromARGB(255, 3, 101, 146), Colors.blueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.15)
      ..quadraticBezierTo(
          size.width * 0.48, size.height * 0.38, size.width, size.height * 0.25)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
