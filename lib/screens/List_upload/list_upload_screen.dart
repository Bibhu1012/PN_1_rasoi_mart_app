// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rasoimart/screens/AppStateManagment/app_state.dart'; // To show User Location

// class ListUploadScreen extends StatefulWidget {
//   const ListUploadScreen({super.key});

//   @override
//   State<ListUploadScreen> createState() => _ListUploadScreenState();
// }

// class _ListUploadScreenState extends State<ListUploadScreen> {
//   // --- Form & Input State ---
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _listTextController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   File? _selectedImage;
//   bool _isLoading = false;

//   // --- Theme Colors ---
//   static const Color appBackgroundColor = Color(0xFFF1E4CE);
//   static const Color appOrange = Color(0xFFECA369);
//   static const Color appBrown = Colors.brown;

//   @override
//   void dispose() {
//     _listTextController.dispose();
//     super.dispose();
//   }

//   // --- Feature Logic: Handling Gallery/Camera ---
//   Future<void> _pickImage(ImageSource source) async {
//     setState(() => _isLoading = true);
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         maxWidth: 1000, // Optimize image size for upload
//         imageQuality: 85,
//       );
//       if (pickedFile != null) {
//         setState(() {
//           _selectedImage = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error accessing camera/gallery: $e")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // --- Submit Logic (Placeholder) ---
//   void _submitList() {
//     if (_formKey.currentState!.validate() || _selectedImage != null) {
//       // Logic: Send text and/or image to API
//       String text = _listTextController.text;
//       String? imagePath = _selectedImage?.path;

//       debugPrint("Submitting List Text: $text");
//       debugPrint("Submitting List Image: $imagePath");

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("List submitted! Our team will contact you soon.")),
//       );
//       // Optional: Navigator.pop(context); // Go back to Home
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please write the items or upload a list image")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: appBackgroundColor,
//       appBar: _buildAppBar(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildLocationHeader(),
//               const SizedBox(height: 20),
//               _buildHowItWorksCard(),
//               const SizedBox(height: 25),
//               _buildTextInputSection(),
//               const SizedBox(height: 25),
//               _buildImageUploadSection(),
//               const SizedBox(height: 40),
//               _buildSubmitButton(),
//               const SizedBox(height: 50),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- UI WIDGETS MATCHING FIGMA ---

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.black),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text(
//         "Upload Shopping List",
//         style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
//       ),
//     );
//   }

//   // Uses Global Notifier for User's Saved Location
//   Widget _buildLocationHeader() {
//     return ValueListenableBuilder<Map<String, String>>(
//       valueListenable: userProfileNotifier,
//       builder: (context, profile, _) {
//         return Row(
//           children: [
//             const Icon(Icons.location_on, size: 16, color: appBrown),
//             const SizedBox(width: 5),
//             Expanded(
//               child: Text(
//                 "Deliver to ${profile['location']}",
//                 style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Matches the explanation card in the Figma design
//   Widget _buildHowItWorksCard() {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: appBrown.withOpacity(0.08), // Using Theme Brown, soft opacity
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: appBrown.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.info_outline, color: appBrown, size: 28),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Order by List",
//                   style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14, color: appBrown),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Our team will call you back to confirm the prices and availability of items in your list.",
//                   style: TextStyle(fontSize: 12, color: Colors.brown.shade700, height: 1.4),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextInputSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Option 1: Write List",
//           style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 15),
//         ),
//         const SizedBox(height: 10),
//         TextFormField(
//           controller: _listTextController,
//           maxLines: 6,
//           decoration: InputDecoration(
//             hintText: "1. 2kg Aashirvaad Atta\n2. 1L Fortune Oil\n3. 1kg Red Chilli Powder...",
//             hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: const BorderSide(color: appOrange, width: 2),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // This handles Camera, Gallery, and the Preview
//   Widget _buildImageUploadSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Option 2: Upload Photo of List",
//           style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 15),
//         ),
//         const SizedBox(height: 10),
        
//         if (_isLoading) ...[
//           const Center(child: CircularProgressIndicator(color: appOrange)),
//           const SizedBox(height: 10),
//         ],

//         Row(
//           children: [
//             // Gallery Button (Matches Orange from Figma, but themed)
//             Expanded(child: _actionBtn("Gallery", Icons.image, () => _pickImage(ImageSource.gallery), Colors.amber.shade700)),
//             const SizedBox(width: 10),
//             // Camera Button (Matches Blue from Figma)
//             Expanded(child: _actionBtn("Camera", Icons.camera_alt, () => _pickImage(ImageSource.camera), Colors.blueGrey)),
//           ],
//         ),
        
//         // Image Preview Area
//         if (_selectedImage != null) _buildImagePreview(),
//       ],
//     );
//   }

//   // Helper for Gallery/Camera buttons
//   Widget _actionBtn(String label, IconData icon, VoidCallback onTap, Color color) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//       onPressed: onTap,
//       icon: Icon(icon, color: Colors.white, size: 18),
//       label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
//     );
//   }

//   // Shows the selected image with a delete button
//   Widget _buildImagePreview() {
//     return Stack(
//       children: [
//         Container(
//           margin: const EdgeInsets.only(top: 20),
//           height: 150,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: Colors.grey.shade300),
//             image: DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover),
//           ),
//         ),
//         Positioned(
//           top: 25, right: 5,
//           child: GestureDetector(
//             onTap: () => setState(() => _selectedImage = null),
//             child: const CircleAvatar(backgroundColor: Colors.redAccent, radius: 15, child: Icon(Icons.close, color: Colors.white, size: 18)),
//           ),
//         ),
//       ],
//     );
//   }

//   // Submit button
//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: appOrange, // Replaced Green with Orange Theme
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         ),
//         onPressed: _submitList,
//         child: Text(
//           "Submit List",
//           style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';

class ListUploadScreen extends StatefulWidget {
  const ListUploadScreen({super.key});

  @override
  State<ListUploadScreen> createState() => _ListUploadScreenState();
}

class _ListUploadScreenState extends State<ListUploadScreen> {
  // --- Controllers & State ---
  final TextEditingController _listTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;
  bool _isWritingList = false;
  bool _showHistory = false; // Toggle between Upload and Saved Lists

  // --- Theme Colors ---
  static const Color appBackgroundColor = Color(0xFFF1E4CE);
  static const Color appOrange = Color(0xFFECA369);
  static const Color appBrown = Colors.brown;

  @override
  void dispose() {
    _listTextController.dispose();
    super.dispose();
  }

  // --- Logic: Image Handling ---
  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _isWritingList = false;
          _showHistory = false;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: appBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Top Drag Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 5, width: 50,
              decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
            ),

            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  _buildHeaderNav(),
                  const SizedBox(height: 15),
                  
                  // Toggle Content based on _showHistory state
                  if (_showHistory)
                    _buildSavedListsView()
                  else
                    _buildUploadView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Main View Components ---

  Widget _buildUploadView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIntroCard(),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader("Shopping Lists", "everything on your list in mins!"),
            _buildHistoryToggleBtn(),
          ],
        ),
        const SizedBox(height: 20),
        if (_isLoading) const Center(child: CircularProgressIndicator(color: appOrange)),
        if (_selectedImage != null) _buildImagePreview(),
        
        Row(
          children: [
            _gridItem(Icons.image_outlined, "Upload Image", () => _pickImage(ImageSource.gallery), active: false),
            const SizedBox(width: 10),
            _gridItem(Icons.camera_alt_outlined, "Click Photo", () => _pickImage(ImageSource.camera), active: false),
            const SizedBox(width: 10),
            _gridItem(Icons.edit_note_outlined, "Write List", () {
              setState(() {
                _isWritingList = !_isWritingList;
                if (_isWritingList) _selectedImage = null;
              });
            }, active: _isWritingList),
          ],
        ),

        if (_isWritingList) _buildTextInputSection(),
        const SizedBox(height: 30),
        _buildSubmitButton(),
      ],
    );
  }

  // --- Saved Lists (History) View ---
  Widget _buildSavedListsView() {
    // Mock data for demonstration - in real app, fetch from database
    final List<Map<String, String>> mockHistory = [
      {'date': '22 April, 2026', 'type': 'Image Upload', 'status': 'Delivered'},
      {'date': '15 April, 2026', 'type': 'Text List', 'status': 'Processing'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => setState(() => _showHistory = false),
            ),
            _buildSectionHeader("Previous Lists", "Your recent shopping history"),
          ],
        ),
        const SizedBox(height: 15),
        ...mockHistory.map((item) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: appOrange.withOpacity(0.1),
              child: Icon(item['type'] == 'Text List' ? Icons.notes : Icons.image, color: appOrange, size: 20),
            ),
            title: Text(item['date']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(item['type']!, style: const TextStyle(fontSize: 12)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(5)),
              child: Text(item['status']!, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        )).toList(),
        if (mockHistory.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text("No saved lists yet", style: TextStyle(color: Colors.grey)),
          )),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeaderNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rasoi Mart", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 22)),
            ValueListenableBuilder<Map<String, String>>(
              valueListenable: userProfileNotifier,
              builder: (context, profile, _) => Text(
                "Deliver to ${profile['location']}",
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel, color: Colors.black45, size: 30),
        )
      ],
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: appBrown, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, color: appOrange, size: 50),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Introducing Shopping List", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 5),
                Text("upload your shopping list and place the order", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryToggleBtn() {
    return TextButton.icon(
      onPressed: () => setState(() => _showHistory = true),
      icon: const Icon(Icons.history, size: 16, color: appBrown),
      label: const Text("Saved Lists", style: TextStyle(color: appBrown, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _gridItem(IconData icon, String label, VoidCallback onTap, {required bool active}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: active ? appOrange.withOpacity(0.2) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: active ? appOrange : Colors.brown.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: active ? appOrange : appBrown, size: 28),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: active ? appOrange : Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          height: 120, width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover),
          ),
        ),
        Positioned(top: 5, right: 5, child: GestureDetector(
          onTap: () => setState(() => _selectedImage = null),
          child: const CircleAvatar(backgroundColor: Colors.red, radius: 12, child: Icon(Icons.close, color: Colors.white, size: 14)),
        ))
      ],
    );
  }

  Widget _buildTextInputSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: _listTextController,
        maxLines: 4,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Start typing items here...",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: appOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          // Process Checkout
        },
        child: Text("Checkout Payments", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}