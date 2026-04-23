import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';

class UPIAddDialog extends StatefulWidget {
  const UPIAddDialog({super.key});

  @override
  State<UPIAddDialog> createState() => _UPIAddDialogState();
}

class _UPIAddDialogState extends State<UPIAddDialog> {
  final TextEditingController _upiController = TextEditingController();
  
  // List of common UPI providers for the suggestions row
  final List<String> suggestions = ["@ybl", "@okaxis", "@oksbi", "@paytm", "@ibl"];
  
  String? errorText;

  // Logic to validate the UPI format (contains characters, an '@', and a provider)
  bool _isValidUPI(String upi) {
    final upiRegex = RegExp(r'^[\w.-]+@[\w.-]+$');
    return upiRegex.hasMatch(upi);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF1E4CE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Add UPI ID", 
        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18)
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _upiController,
            // Clear error text as soon as the user starts typing again
            onChanged: (val) {
              if (errorText != null) setState(() => errorText = null);
            },
            decoration: InputDecoration(
              hintText: "Enter UPI ID (e.g. name@upi)",
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              errorText: errorText,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          const Text(
            "Suggestions:",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 8),
          
          // Horizontal scrolling list for UPI suggestions
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  label: Text(s, style: const TextStyle(color: Colors.brown, fontSize: 12)),
                  onPressed: () {
                    String currentText = _upiController.text;
                    // Logic to swap or append the suggestion
                    if (currentText.contains('@')) {
                      _upiController.text = currentText.split('@')[0] + s;
                    } else {
                      _upiController.text = currentText + s;
                    }
                    // Move cursor to the end
                    _upiController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _upiController.text.length)
                    );
                  },
                ),
              )).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            String input = _upiController.text.trim();
            
            if (_isValidUPI(input)) {
              // 1. Create a copy of the current list from global state
              var newList = List<Map<String, String>>.from(savedUPINotifier.value);
              
              // 2. Add the new entry
              newList.add({
                'id': input,
                'provider': _determineProvider(input),
              });
              
              // 3. Update the global notifier to trigger a UI refresh
              savedUPINotifier.value = newList;
              
              Navigator.pop(context);
            } else {
              setState(() => errorText = "Please enter a valid UPI format");
            }
          },
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // Purely aesthetic: tries to guess the app name based on the handle
  String _determineProvider(String upi) {
    if (upi.contains('ybl') || upi.contains('ibl')) return "PhonePe";
    if (upi.contains('oksbi') || upi.contains('okaxis')) return "Google Pay";
    if (upi.contains('paytm')) return "Paytm";
    return "UPI Payment";
  }

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }
}