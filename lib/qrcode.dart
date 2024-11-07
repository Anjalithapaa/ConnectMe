import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String linkedIn;
  final String photoUrl;
  final String organization;
  final String title;

  const QRCodeScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.organization,
    required this.title,
    required this.linkedIn,
  });

  @override
  Widget build(BuildContext context) {
    // Create a URL that contains query parameters with the user information
    String qrData = "https://host-connect-me.vercel.app/contact.html?"
        "name=${Uri.encodeComponent(name)}"
        "&email=${Uri.encodeComponent(email)}"
        "&phone=${Uri.encodeComponent(phone)}"
        "&linkedIn=${Uri.encodeComponent(linkedIn)}"
        "&photoUrl=${Uri.encodeComponent(photoUrl)}"
        "&organization=${Uri.encodeComponent(organization)}"
        "&title=${Uri.encodeComponent(title)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
      ),
      body: Center(
        child: QrImageView(
          data: qrData, // Encode the valid URL in the QR code
          version: QrVersions.auto,
          size: 320,
          gapless: false,
        ),
      ),
    );
  }
}
