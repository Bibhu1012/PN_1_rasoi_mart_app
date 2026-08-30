import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rasoimart/screens/Bottom_Tabs/Home/home_screen.dart';
import 'package:rasoimart/screens/AppStateManagment/profile_state.dart';
import 'package:rasoimart/screens/My_Account/Address/address_screen.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  File? _image;
  bool _isVerifying = false;
  bool _emailVerified = false;

  // Function to pick image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Simple Email Verification Simulation
  void _verifyEmail() {
    if (_emailController.text.contains('@') && _emailController.text.contains('.')) {
      setState(() => _isVerifying = true);
      
      // Simulating a 2-second delay for "sending link"
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isVerifying = false;
          _emailVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email verified successfully!")),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email first")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Complete Your Profile",
                style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // --- PROFILE PICTURE SECTION ---
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null 
                          ? const Icon(Icons.person, size: 60, color: Colors.grey) 
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color(0xFFECA369), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- NAME FIELD ---
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (val) => val!.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 20),

              // --- EMAIL FIELD WITH VERIFY BUTTON ---
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      enabled: !_emailVerified,
                      decoration: InputDecoration(
                        labelText: "Email ID",
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: _emailVerified || _isVerifying ? null : _verifyEmail,
                    child: _isVerifying 
                        ? const CircularProgressIndicator(value: 20) 
                        : Text(_emailVerified ? "VERIFIED" : "VERIFY", 
                            style: TextStyle(color: _emailVerified ? Colors.green : Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              
              const SizedBox(height: 100),

              // --- NEXT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_emailVerified) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please verify email first")));
                        return;
                      }

                      // Save to Global State for use in Profile/Main Screen
                      ProfileState.name = _nameController.text;
                      ProfileState.email = _emailController.text;
                      ProfileState.profileImage = _image;

                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressScreen()));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFECA369),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("NEXT", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}