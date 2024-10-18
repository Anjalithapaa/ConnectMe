import 'package:flutter/material.dart';
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
  String photoUrl = '';
  String title = '';
  String organization = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Details'),
        backgroundColor: const Color.fromARGB(255, 3, 101, 146), // Header color
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
                        color: Colors.black54, // Shadow color
                        offset: Offset(2, 2), // Position of the shadow
                        blurRadius: 4, // How blurred the shadow is
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Name', 'Enter your name', (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                }, (value) {
                  setState(() {
                    name = value;
                  });
                }),
                const SizedBox(height: 16),
                _buildTextField('Email', 'Enter your email', (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                }, (value) {
                  setState(() {
                    email = value;
                  });
                }),
                const SizedBox(height: 16),
                _buildTextField('Phone Number', 'Enter your phone number',
                    (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                }, (value) {
                  setState(() {
                    phone = value;
                  });
                }),
                const SizedBox(height: 16),
                _buildTextField('Photo URL', 'Enter photo URL', (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a photo URL';
                  }
                  return null;
                }, (value) {
                  setState(() {
                    photoUrl = value;
                  });
                }),
                const SizedBox(height: 16,),
                _buildTextField('Organization','Enter your organization',(value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter your Organization';
                  }
                  return null;
                },(value){
                  setState(() {
                    organization = value;
                  });
                }),
                const SizedBox(height: 16,),
                _buildTextField('Title','Enter your Title',(value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter your Title';
                  }
                  return null;
                },(value){
                  setState(() {
                    title = value;
                  });
                }),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessCard(
                            name: name,
                            email: email,
                            phone: phone,
                            photoUrl: photoUrl,
                            organization: organization,
                            title: title,
                            

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
                    backgroundColor:
                        const Color.fromARGB(255, 3, 101, 146), // Button color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20), // Added padding
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

  Widget _buildTextField(String label, String hint,
      FormFieldValidator<String>? validator, ValueChanged<String>? onChanged) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint, // Placeholder text
        hintStyle:
            const TextStyle(color: Colors.black54), // Changed placeholder color
        labelStyle: const TextStyle(
            color: Color.fromARGB(
                255, 3, 101, 146)), // Label color changed to your primary color
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(
                  255, 3, 101, 146)), // Border color changed to primary color
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 3, 101, 146)), // Focused border color
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.white, // Background color
        filled: true,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
