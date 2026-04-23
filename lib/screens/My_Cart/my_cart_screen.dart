import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  // Helper to update quantity in the global cartNotifier
  void _updateQuantity(int index, bool increase) {
    List<Map<String, String>> updatedList = List.from(cartNotifier.value);
    int currentQty = int.tryParse(updatedList[index]['quantity'] ?? '1') ?? 1;

    if (increase) {
      currentQty++;
    } else {
      currentQty--;
    }

    if (currentQty > 0) {
      updatedList[index]['quantity'] = currentQty.toString();
    } else {
      updatedList.removeAt(index);
    }
    
    // This triggers the ValueListenableBuilder to rebuild the UI
    cartNotifier.value = updatedList;
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
        title: Text(
          "My Cart",
          style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: cartNotifier,
        builder: (context, cartItems, child) {
          if (cartItems.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return _buildCartItem(cartItems[index], index);
                  },
                ),
              ),
              _buildCheckoutSummary(cartItems),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(Map<String, String> item, int index) {
    int quantity = int.tryParse(item['quantity'] ?? '1') ?? 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          // Product Image placeholder
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF1E4CE),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.brown),
          ),
          const SizedBox(width: 15),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Product',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item['weight'] ?? 'Unit',
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 5),
                Text(
                  item['price']!.contains('₹') ? item['price']! : "₹${item['price']}",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 16),
                ),
              ],
            ),
          ),
          // Quantity Counter
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1E4CE).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _updateQuantity(index, false),
                  icon: const Icon(Icons.remove, size: 18, color: Colors.brown),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                Text(
                  '$quantity',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                IconButton(
                  onPressed: () => _updateQuantity(index, true),
                  icon: const Icon(Icons.add, size: 18, color: Colors.brown),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSummary(List<Map<String, String>> items) {
    double subtotal = 0;
    for (var item in items) {
      String cleanPrice = item['price']!.replaceAll(RegExp(r'[^0-9]'), '');
      double price = double.tryParse(cleanPrice) ?? 0;
      int qty = int.tryParse(item['quantity'] ?? '1') ?? 1;
      subtotal += (price * qty);
    }
    
    double deliveryCharge = subtotal > 0 ? 40.0 : 0.0;
    double total = subtotal + deliveryCharge;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow("Subtotal", "₹${subtotal.toInt()}"),
            const SizedBox(height: 10),
            _summaryRow("Delivery Fee", "₹${deliveryCharge.toInt()}"),
            const Divider(height: 30),
            _summaryRow("Total Amount", "₹${total.toInt()}", isTotal: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Checkout logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: Text(
                  "Proceed to Checkout",
                  style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.brown : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 15),
          Text(
            "Your cart is empty!",
            style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10),
          Text(
            "Add some items to get started.",
            style: GoogleFonts.montserrat(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}