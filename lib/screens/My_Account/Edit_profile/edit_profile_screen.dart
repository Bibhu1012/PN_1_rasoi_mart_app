import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rasoimart/screens/AppStateManagment/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  
  File? _selectedImage;
  bool _canChangeName = true;
  int _daysRemaining = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ProfileState.name);
    _emailController = TextEditingController(text: ProfileState.email);
    _phoneController = TextEditingController(text: "9939963986"); // Example phone

    _checkNameChangeEligibility();
  }

  void _checkNameChangeEligibility() {
    if (ProfileState.lastNameChangeDate != null) {
      final difference = DateTime.now().difference(ProfileState.lastNameChangeDate!).inDays;
      if (difference < 30) {
        setState(() {
          _canChangeName = false;
          _daysRemaining = 30 - difference;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _saveProfile() {
    if (_nameController.text.isEmpty) return;

    // Update Name and timestamp if it was changed
    if (_canChangeName && _nameController.text != ProfileState.name) {
      ProfileState.name = _nameController.text;
      ProfileState.lastNameChangeDate = DateTime.now();
    }

    // Replace Image
    if (_selectedImage != null) {
      ProfileState.profileImage = _selectedImage;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Edit Profile", style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildImagePicker(),
            const SizedBox(height: 30),
            
            // Name Field with 30-day restriction logic
            _buildEditField(
              "Full Name", 
              _nameController, 
              Icons.person_outline, 
              enabled: _canChangeName,
              helperText: _canChangeName ? null : "You can change your name again in $_daysRemaining days",
            ),
            
            const SizedBox(height: 15),
            
            // Email and Phone are read-only (enabled: false)
            _buildEditField("Email Address", _emailController, Icons.email_outlined, enabled: false),
            const SizedBox(height: 15),
            _buildEditField("Phone Number", _phoneController, Icons.phone_android_outlined, enabled: false),
            
            const SizedBox(height: 40),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.brown.shade200,
            backgroundImage: _selectedImage != null 
                ? FileImage(_selectedImage!) 
                : (ProfileState.profileImage != null ? FileImage(ProfileState.profileImage!) : null) as ImageProvider?,
            child: (_selectedImage == null && ProfileState.profileImage == null) 
                ? const Icon(Icons.person, size: 60, color: Colors.white) 
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon, {bool enabled = true, String? helperText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.brown)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          style: TextStyle(color: enabled ? Colors.black : Colors.grey),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.brown),
            helperText: helperText,
            helperStyle: const TextStyle(color: Colors.red, fontSize: 11),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: _saveProfile,
        child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}