import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/My_Account/Address/Map_picker/MapPickerScreen.dart';

class ManageAddressScreen extends StatefulWidget {
  final Map<String, String>? addressData;
  final bool isEditing;

  const ManageAddressScreen({super.key, this.addressData, this.isEditing = false});

  @override
  State<ManageAddressScreen> createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if editing, otherwise empty
    _titleController = TextEditingController(text: widget.addressData?['title'] ?? '');
    _addressController = TextEditingController(text: widget.addressData?['address'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Logic to open Map and receive the address string back
  Future<void> _pickAddressFromMap() async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerScreen()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _addressController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.isEditing ? "Edit Address" : "Add New Address",
          style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address Label",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "e.g. Home, Office, Gym",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value!.isEmpty ? "Please give this address a name" : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Full Address",
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  TextButton.icon(
                    onPressed: _pickAddressFromMap,
                    icon: const Icon(Icons.map, size: 18, color: Colors.brown),
                    label: const Text("Pick from Map", style: TextStyle(color: Colors.brown)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter address details manually or use the map...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value!.isEmpty ? "Address details are required" : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Return the data to AddressScreen
                      Navigator.pop(context, {
                        'title': _titleController.text.trim(),
                        'address': _addressController.text.trim(),
                      });
                    }
                  },
                  child: Text(
                    widget.isEditing ? "Update Address" : "Save Address",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}