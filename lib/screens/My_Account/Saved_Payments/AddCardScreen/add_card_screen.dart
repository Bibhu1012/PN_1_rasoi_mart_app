import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for FilteringTextInputFormatter
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  String cardNumber = "XXXX XXXX XXXX";
  String expiryDate = "MM/YY";
  String cardHolder = "FULL NAME";
  String bankName = "NEW BANK CARD";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Add Details", style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Preview Card
            Container(
              height: 200, width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.brown.shade800, borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(bankName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                  Text(cardNumber, style: GoogleFonts.sourceCodePro(color: Colors.white, fontSize: 22, letterSpacing: 2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cardHolder.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(expiryDate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // CARD NUMBER: Limit 12, Numbers only
            _buildTextField("Card Number", (val) {
              setState(() => cardNumber = val.isEmpty ? "XXXX XXXX XXXX" : val);
            }, limit: 12, isNumber: true),

            const SizedBox(height: 15),
            _buildTextField("Bank Name", (val) => setState(() => bankName = val)),

            const SizedBox(height: 15),
            _buildTextField("Card Holder Name", (val) => setState(() => cardHolder = val)),

            const SizedBox(height: 15),
            Row(
              children: [
                // EXPIRY: Auto-slash logic
                Expanded(child: _buildExpiryField()),
                const SizedBox(width: 15),
                // CVV: Limit 3, Numbers only
                Expanded(child: _buildTextField("CVV", (val) {}, limit: 3, isNumber: true, obscure: true)),
              ],
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () {
  final newCard = {
    'bank': bankName,
    'number': cardNumber.length > 4 ? cardNumber.substring(cardNumber.length - 4) : cardNumber,
    'holder': cardHolder, // <--- ADD THIS LINE
    'color': 'brown',
  };
  savedCardsNotifier.value = [...savedCardsNotifier.value, newCard];
  Navigator.pop(context);
},
                child: const Text("Save Card", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper for Card Number and CVV
  Widget _buildTextField(String label, Function(String) onChanged, {int? limit, bool isNumber = false, bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      onChanged: onChanged,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (limit != null) LengthLimitingTextInputFormatter(limit),
        if (isNumber) FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: label,
        filled: true, fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  // Helper for Expiry Date with Auto-Slash
  Widget _buildExpiryField() {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
        FilteringTextInputFormatter.digitsOnly,
        _ExpiryInputFormatter(),
      ],
      onChanged: (val) => setState(() => expiryDate = val.isEmpty ? "MM/YY" : val),
      decoration: InputDecoration(
        labelText: "Expiry (MM/YY)",
        filled: true, fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}

// Logic for automatic slash (MM/YY)
class _ExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/'); 
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}