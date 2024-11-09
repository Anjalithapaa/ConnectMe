import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

class QRCodeScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String linkedIn;
  final String photoUrl;
  final String organization;
  final String title;

  const QRCodeScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.organization,
    required this.title,
    required this.linkedIn,
  }) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey _qrKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _saveQrCode() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Find the RenderRepaintBoundary
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Convert to image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        // Convert ByteData to bytes
        final bytes = byteData.buffer.asUint8List();

        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/qr_code.png';

        // Save to temporary file
        File(imagePath).writeAsBytesSync(bytes);

        // Save to gallery
        await GallerySaver.saveImage(imagePath);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR Code saved to gallery!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving QR Code: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String qrData = "https://host-connect-me.vercel.app/contact.html?"
        "name=${Uri.encodeComponent(widget.name)}"
        "&email=${Uri.encodeComponent(widget.email)}"
        "&phone=${Uri.encodeComponent(widget.phone)}"
        "&linkedIn=${Uri.encodeComponent(widget.linkedIn)}"
        "&photoUrl=${Uri.encodeComponent(widget.photoUrl)}"
        "&organization=${Uri.encodeComponent(widget.organization)}"
        "&title=${Uri.encodeComponent(widget.title)}";

    return Scaffold(
      appBar: AppBar(
          title: const Text('Your QR Code'),
          backgroundColor: const Color.fromARGB(255, 3, 101, 146)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RepaintBoundary(
              key: _qrKey,
              child: Container(
                color: Colors.white,
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
          ElevatedButton(
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
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save QR Code to Gallery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
