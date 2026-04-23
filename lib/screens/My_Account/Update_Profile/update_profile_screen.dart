import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateProfileScreen extends StatefulWidget {
  // We pass the current data so the fields are pre-filled correctly
  final Map<String, String> currentData;

  const UpdateProfileScreen({super.key, required this.currentData});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _sendEmails = true;
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  static const Color appBackgroundColor = Color(0xFFF1E4CE);
  static const Color appMainButtonColor = Color(0xFFDC2626);
  static const Color inputLabelColor = Color(0xFFB4B0A7);

  @override
  void initState() {
    super.initState();
    // Initialize controllers with passed data
    _nameController = TextEditingController(text: widget.currentData['name']);
    _phoneController = TextEditingController(text: widget.currentData['phone']);
    _emailController = TextEditingController(text: widget.currentData['email']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          "Update Profile",
          style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 22),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // --- PROFILE IMAGE EDIT OPTION ---
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Logic to pick image from gallery would go here
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              _buildUpdateInputField("Name :", _nameController, TextInputType.text),
              const SizedBox(height: 15),
              _buildUpdateInputField("Mobile Number :", _phoneController, TextInputType.phone),
              const SizedBox(height: 15),
              _buildUpdateInputField("Email :", _emailController, TextInputType.emailAddress),
              const SizedBox(height: 30),

              Row(
                children: [
                  Checkbox(
                    value: _sendEmails,
                    activeColor: const Color(0xFF4CAF50),
                    onChanged: (val) => setState(() => _sendEmails = val!),
                  ),
                  Expanded(
                    child: Text("Send me emails on promotions, offers and service",
                        style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey.shade700)),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // --- SAVE CHANGES BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Send the new data back to MyAccountScreen
                    Navigator.pop(context, {
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'email': _emailController.text,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appMainButtonColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Save Changes', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateInputField(String label, TextEditingController controller, TextInputType inputType) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFAFAFA0), width: 2.0)),
      ),
      child: Row(
        children: [
          Text(label, style: GoogleFonts.montserrat(fontSize: 16, color: inputLabelColor, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: inputType,
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
            ),
          ),
          const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}