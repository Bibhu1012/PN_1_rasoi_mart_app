import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'package:rasoimart/screens/My_Cart/my_cart_screen.dart';

class SaveForLaterScreen extends StatefulWidget {
  const SaveForLaterScreen({super.key});

  @override
  State<SaveForLaterScreen> createState() => _SaveForLaterScreenState();
}

class _SaveForLaterScreenState extends State<SaveForLaterScreen> {
  // Simulated database for saved items
  List<Map<String, String>> savedItems = [
    {'id': '1', 'name': 'Premium Basmati Rice', 'weight': '5 kg', 'price': '540'},
    {'id': '2', 'name': 'Organic Turmeric', 'weight': '200g', 'price': '85'},
    {'id': '3', 'name': 'Fortune Mustard Oil', 'weight': '1 Ltr', 'price': '158'},
  ];

  void _removeItem(int index) {
    setState(() {
      savedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Saved for Later", 
          style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: savedItems.isEmpty 
          ? _buildEmptyState() 
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final item = savedItems[index];
                return _modernProductCard(item, index);
              },
            ),
    );
  }

  Widget _modernProductCard(Map<String, String> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image Area
            Container(
              height: 90, width: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE5D5B8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.shopping_basket_outlined, color: Colors.brown, size: 30),
            ),
            const SizedBox(width: 15),
            // Info Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name']!, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(item['weight']!, style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text("₹${item['price']}", style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, fontSize: 18, color: const Color(0xFF795548))),
                ],
              ),
            ),
            // Actions
            Column(
              children: [
                IconButton(
                  onPressed: () => _removeItem(index),
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                ),
                GestureDetector(
                  onTap: () {
  // 1. Create a NEW list containing the old items PLUS the new item
  // This forces ValueNotifier to notify all listeners (like the Cart Screen)
  cartNotifier.value = [...cartNotifier.value, item];

  // 2. Remove from the local saved list UI
  _removeItem(index);

  // 3. Optional: Print to console to verify data is moving
  print("Cart Count: ${cartNotifier.value.length}");

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Item moved to cart!")),
  );
},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
                    child: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border_rounded, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text("Nothing saved yet!", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}