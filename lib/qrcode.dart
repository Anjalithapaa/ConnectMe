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
  });

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey _qrKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  bool _isSaving = false;
  bool _isDownloading = false;

  Future<void> _capturePng(GlobalKey key, String filename) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/$filename.png';
        final bytes = byteData.buffer.asUint8List();

        File(imagePath).writeAsBytesSync(bytes);
        await GallerySaver.saveImage(imagePath);
        return;
      }
      throw Exception('Failed to capture image');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveQrCode() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _capturePng(
          _qrKey, 'qr_code_${DateTime.now().millisecondsSinceEpoch}');

      if (mounted) {
        // In _saveQrCode function, update the SnackBar:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('QR Code saved to gallery!'),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 3, 101, 146),
            behavior: SnackBarBehavior.floating, // Makes the SnackBar float
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height -
                  170, // Positions it higher
              left: 10,
              right: 10,
            ),
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Flexible(
                  child: Text('Error saving QR Code: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _saveCard() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      await _capturePng(
          _cardKey, 'business_card_${DateTime.now().millisecondsSinceEpoch}');

      if (mounted) {
        // Similarly in _saveCard function:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Business Card saved to gallery!'),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 3, 101, 146),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 170,
              left: 10,
              right: 10,
            ),
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // And for error SnackBars:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Flexible(
                  child: Text('Error saving: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 170,
              left: 10,
              right: 10,
            ),
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
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
        /* "&photoUrl=${Uri.encodeComponent(widget.photoUrl)}"*/
        "&organization=${Uri.encodeComponent(widget.organization)}"
        "&title=${Uri.encodeComponent(widget.title)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR Code'),
        backgroundColor: const Color.fromARGB(255, 3, 101, 146),
        foregroundColor: Colors.white,
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
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.photoUrl),
                        onBackgroundImageError: (e, s) {},
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
