import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:convert';


class QRCodeScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String linkedIn;
  /*final String photoUrl; */
  final String organization;
  final String title;

  const QRCodeScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    /* required this.photoUrl,*/
    required this.organization,
    required this.title,
    required this.linkedIn,
    required String photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Create a URL that contains query parameters with the user information
    String qrData = "https://host-connect-me.vercel.app/contact.html?"
      
        "name=${Uri.encodeComponent(widget.name)}"
        "&email=${Uri.encodeComponent(widget.email)}"
        "&phone=${Uri.encodeComponent(widget.phone)}"
        "&linkedIn=${Uri.encodeComponent(widget.linkedIn)}"
        // "&photoUrl=${Uri.encodeComponent(widget.photoUrl)}"
        "&organization=${Uri.encodeComponent(widget.organization)}"
        "&title=${Uri.encodeComponent(widget.title)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
      ),
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent.withOpacity(0.8),
              Colors.blue.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: RepaintBoundary(
                  key: _qrKey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RepaintBoundary(
                key: _cardKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // In QRCodeScreen.dart, modify the CircleAvatar:
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: widget.photoUrl.isNotEmpty
                            ? MemoryImage(base64Decode(widget.photoUrl))
                            : null,
                        onBackgroundImageError: (e, s) {
                          print('Error loading image: $e');
                        },
                        child: widget.photoUrl.isEmpty
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.organization,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(height: 32),
                      ListTile(
                        leading: const Icon(Icons.email,
                            color: Color.fromARGB(255, 3, 101, 146)),
                        title: Text(widget.email),
                        dense: true,
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone,
                            color: Color.fromARGB(255, 3, 101, 146)),
                        title: Text(widget.phone),
                        dense: true,
                      ),
                      ListTile(
                        leading: const Icon(Icons.link,
                            color: Color.fromARGB(255, 3, 101, 146)),
                        title: Text(widget.linkedIn),
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveQrCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 101, 146),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      elevation: 5,
                    ),
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.qr_code),
                    label: const Text(
                      'Save QR Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: _isDownloading ? null : _saveCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 101, 146),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      elevation: 5,
                    ),
                    icon: _isDownloading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.download),
                    label: const Text(
                      'Save Card',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),

        ),
      ),
    );
  }
}
