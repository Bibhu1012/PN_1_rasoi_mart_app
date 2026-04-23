import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'package:rasoimart/screens/My_Account/Saved_Payments/AddCardScreen/add_card_screen.dart';

class SavedPaymentsScreen extends StatelessWidget {
  const SavedPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final words = translations[currentLang]!;

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
              words['saved_payments'] ?? "Saved Payments",
              style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Cards (Long press to remove)"),
                const SizedBox(height: 12),
                
                // --- DYNAMIC CARDS LIST ---
                ValueListenableBuilder<List<Map<String, String>>>(
                  valueListenable: savedCardsNotifier,
                  builder: (context, cardList, child) {
                    return Column(
                      children: cardList.asMap().entries.map((entry) {
                        return _buildPaymentCard(
                          context, 
                          entry.key, 
                          entry.value['bank']!, 
                          entry.value['number']!, 
                          entry.value['holder'] ?? "USER", 
                          Colors.brown.shade700
                        );
                      }).toList(),
                    );
                  },
                ),
                
                const SizedBox(height: 25),
                _buildSectionHeader("UPI IDs (Long press to remove)"),
                const SizedBox(height: 12),

                // --- DYNAMIC UPI LIST ---
                ValueListenableBuilder<List<Map<String, String>>>(
                  valueListenable: savedUPINotifier,
                  builder: (context, upiList, child) {
                    return Column(
                      children: upiList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onLongPress: () => _confirmDeleteUPI(context, entry.key),
                          child: _buildUPITile(entry.value['id']!, entry.value['provider']!),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 30),
                _buildAddButton(context, "Add New Card / UPI"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown));
  }

  Widget _buildUPITile(String upiId, String provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: Colors.black12)
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet, color: Colors.brown),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(upiId, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(provider, style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, int index, String bank, String lastDigits, String holderName, Color overlayColor) {
    return GestureDetector(
      onLongPress: () => _confirmDeleteCard(context, index),
      child: Container(
        width: double.infinity, height: 190, margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network('https://images.unsplash.com/photo-1550565118-3a14e8d0386f?q=80&w=2070&auto=format&fit=crop', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [overlayColor.withOpacity(0.8), Colors.black.withOpacity(0.6)]))),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(bank, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)), const Icon(Icons.contactless, color: Colors.white)]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("**** **** **** $lastDigits", style: GoogleFonts.sourceCodePro(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Text(holderName.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteCard(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Card?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () {
            var list = List<Map<String, String>>.from(savedCardsNotifier.value);
            list.removeAt(index);
            savedCardsNotifier.value = list;
            Navigator.pop(context);
          }, child: const Text("Remove", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  void _confirmDeleteUPI(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove UPI?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () {
            var list = List<Map<String, String>>.from(savedUPINotifier.value);
            list.removeAt(index);
            savedUPINotifier.value = list;
            Navigator.pop(context);
          }, child: const Text("Remove", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, String text) {
    return Container(
      width: double.infinity, height: 60,
      decoration: BoxDecoration(border: Border.all(color: Colors.brown.withOpacity(0.5)), borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: TextButton.icon(
          onPressed: () => _showAddOptions(context), 
          icon: const Icon(Icons.add_circle_outline, color: Colors.brown), 
          label: Text(text, style: GoogleFonts.montserrat(color: Colors.brown, fontWeight: FontWeight.bold))
        )
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF1E4CE),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.brown),
              title: const Text("Add New Card"),
              onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCardScreen())); },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.brown),
              title: const Text("Add New UPI ID"),
              onTap: () { Navigator.pop(context); _showUPIDialog(context); },
            ),
          ],
        ),
      ),
    );
  }

  void _showUPIDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const UPIAddDialog());
  }
}

// --- UPI DIALOG COMPONENT ---
class UPIAddDialog extends StatefulWidget {
  const UPIAddDialog({super.key});

  @override
  State<UPIAddDialog> createState() => _UPIAddDialogState();
}

class _UPIAddDialogState extends State<UPIAddDialog> {
  final TextEditingController _upiController = TextEditingController();
  final List<String> suggestions = ["@ybl", "@okaxis", "@oksbi", "@paytm"];
  String? errorText;

  bool _isValidUPI(String upi) {
    final upiRegex = RegExp(r'^[\w.-]+@[\w.-]+$');
    return upiRegex.hasMatch(upi);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF1E4CE),
      title: Text("Add UPI ID", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _upiController,
            onChanged: (val) { if(errorText != null) setState(() => errorText = null); },
            decoration: InputDecoration(
              hintText: "Enter UPI ID",
              errorText: errorText,
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  backgroundColor: Colors.white,
                  label: Text(s, style: const TextStyle(color: Colors.brown, fontSize: 12)),
                  onPressed: () {
                    String currentText = _upiController.text;
                    if (currentText.contains('@')) {
                      _upiController.text = currentText.split('@')[0] + s;
                    } else {
                      _upiController.text = currentText + s;
                    }
                  },
                ),
              )).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
          onPressed: () {
            if (_isValidUPI(_upiController.text)) {
              var newList = List<Map<String, String>>.from(savedUPINotifier.value);
              newList.add({'id': _upiController.text, 'provider': 'UPI Payment'});
              savedUPINotifier.value = newList;
              Navigator.pop(context);
            } else {
              setState(() => errorText = "Not a valid UPI ID");
            }
          },
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}