import 'dart:convert'; // For Base64 encoding
import 'dart:typed_data'; // For handling image bytes
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // For image picker
import 'business_card.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phone = '';
  String linkedIn = '';
  String photoUrl = '';
  String title = '';
  String organization = '';
  Uint8List? _selectedImageBytes; // Store the uploaded image bytes

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController linkedInController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          setState(() {
            nameController.text = doc['name'] ?? '';
            emailController.text = doc['email'] ?? '';
            phoneController.text = doc['phone'] ?? '';
            linkedInController.text = doc['linkedIn'] ?? '';
            try {
              photoUrl = doc['photoUrl'] ?? '';
              if (photoUrl.isNotEmpty) {
                _selectedImageBytes = base64Decode(photoUrl);
              }
            } catch (e) {
              print('Error loading photo: $e');
              photoUrl = '';
              _selectedImageBytes = null;
            }
            titleController.text = doc['title'] ?? '';
            organizationController.text = doc['organization'] ?? '';
          });
        } else {
          print("No document found for this user.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    } else {
      print("No authenticated user found.");
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 50);

      if (pickedFile != null) {
        Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = imageBytes;
          String base64String = base64Encode(imageBytes);
          // Ensure proper padding
          while (base64String.length % 4 != 0) {
            base64String += '=';
          }
          photoUrl = base64String;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _saveUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Validate photoUrl before saving
        String validPhotoUrl = photoUrl;
        if (photoUrl.isNotEmpty) {
          try {
            base64Decode(photoUrl); // Test if valid Base64
          } catch (e) {
            validPhotoUrl = ''; // Reset if invalid
            print('Invalid Base64 string: $e');
          }
        }

        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'linkedIn': linkedInController.text,
          'photoUrl': validPhotoUrl,
          'title': titleController.text,
          'organization': organizationController.text,
        });
      } catch (e) {
        print('Error saving user data: $e');
      }
    }
  }

  Widget _buildTextField(String label, String hint,
      TextEditingController controller, FormFieldValidator<String>? validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        labelStyle: const TextStyle(color: Color.fromARGB(255, 3, 101, 146)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 3, 101, 146)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 3, 101, 146)),
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Details'),
        backgroundColor: const Color.fromARGB(255, 3, 101, 146),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please fill in your details below:',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Name', 'Enter your name', nameController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                }),
                const SizedBox(height: 16),
                _buildTextField('Email', 'Enter your email', emailController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                }),
                const SizedBox(height: 16),
                _buildTextField(
                    'Phone Number', 'Enter your phone number', phoneController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                }),
                const SizedBox(height: 16),
                _buildTextField(
                    'LinkedIn', 'Enter LinkedIn URL', linkedInController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your LinkedIn URL';
                  }
                  return null;
                }),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Upload Photo'),
                    ),
                    const SizedBox(width: 10),
                    _selectedImageBytes != null
                        ? Image.memory(
                            _selectedImageBytes!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : const Text('No image selected'),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField('Organization', 'Enter your organization',
                    organizationController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your organization';
                  }
                  return null;
                }),
                const SizedBox(height: 16),
                _buildTextField('Title', 'Enter your title', titleController,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your title';
                  }
                  return null;
                }),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _saveUserData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessCard(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            photoUrl: photoUrl, // Pass the Base64 image string
                            organization: organizationController.text,
                            title: titleController.text,
                            linkedIn: linkedInController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Create ICard',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 101, 146),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
