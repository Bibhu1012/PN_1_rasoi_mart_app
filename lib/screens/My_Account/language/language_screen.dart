import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // Currently selected language code
  String selectedLanguage = 'en';

  final List<Map<String, String>> languages = [
    {'name': 'English', 'sub': 'Default Language', 'code': 'en'},
    {'name': 'हिन्दी', 'sub': 'Hindi', 'code': 'hi'},
    {'name': 'বাংলা', 'sub': 'Bengali', 'code': 'bn'},
    {'name': 'ગુજરાતી', 'sub': 'Gujarati', 'code': 'gu'},
    {'name': 'ਪੰਜਾਬੀ', 'sub': 'Punjabi', 'code': 'pa'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Choose Language",
          style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Please select your preferred language for a better shopping experience.",
              style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black54),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final lang = languages[index];
                bool isSelected = selectedLanguage == lang['code'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLanguage = lang['code']!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? Colors.brown : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isSelected ? Colors.brown : Colors.grey.shade300,
                          radius: 20,
                          child: Text(
                            lang['name']![0],
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang['name']!,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isSelected ? Colors.brown : Colors.black87,
                                ),
                              ),
                              Text(
                                lang['sub']!,
                                style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Colors.brown, size: 28),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom Confirm Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
  // Update the global setting to whatever the user selected
  languageNotifier.value = selectedLanguage; 
  
  Navigator.pop(context); // Go back to account screen
  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Language Updated!")),
  );
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  "Confirm",
                  style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}