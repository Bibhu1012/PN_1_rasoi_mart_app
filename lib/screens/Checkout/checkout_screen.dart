import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/cart_state.dart';

// ---------------- MODELS ----------------

class DeliveryAddress {
  final String name;
  final String line;
  final String type; // Home / Work / Other
  const DeliveryAddress({required this.name, required this.line, required this.type});
}

enum PaymentMode { card, upi, payLater, cod }

extension PaymentModeLabel on PaymentMode {
  String get label {
    switch (this) {
      case PaymentMode.card:
        return "Debit / Credit Card";
      case PaymentMode.upi:
        return "UPI";
      case PaymentMode.payLater:
        return "Pay Later";
      case PaymentMode.cod:
        return "Cash on Delivery";
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMode.card:
        return Icons.credit_card;
      case PaymentMode.upi:
        return Icons.account_balance_wallet_outlined;
      case PaymentMode.payLater:
        return Icons.schedule;
      case PaymentMode.cod:
        return Icons.payments_outlined;
    }
  }
}

class CheckoutScreen extends StatefulWidget {
  /// Each item: {name, qty, price, old, quantity}
  final List<Map<String, String>> items;

  /// Flag this true/false based on your actual customer eligibility logic
  /// (e.g. order history, credit score, etc.) once that data is available.
  final bool isEligibleForPayLater;

  const CheckoutScreen({super.key, required this.items, this.isEligibleForPayLater = true});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const Color appBackgroundColor = Color(0xFFF1E4CE);
  static const Color appOrange = Color(0xFFECA369);
  static const Color appBrown = Color(0xFF6D4C2B);

  late List<Map<String, dynamic>> _items;

  // ---- TEMPORARY mock saved-address list. -----------------------------
  // Replace this with your real saved-addresses source (e.g. an
  // AddressState.savedAddresses list, similar to how CartState works)
  // once you share that file. Everything below (the bottom sheet, the
  // selection logic) already reads from a plain List<DeliveryAddress>,
  // so swapping the source is a one-line change.
  final List<DeliveryAddress> _savedAddresses = const [
    DeliveryAddress(name: "Tanu", line: "PG, rimi store Newtown, Dharmatala Pachuria", type: "Home"),
    DeliveryAddress(name: "Tanu", line: "Office 4th Floor, Tech Park, Ranchi", type: "Work"),
    DeliveryAddress(name: "Tanu", line: "12, Lake View Road, Kolkata", type: "Other"),
  ];
  late DeliveryAddress _selectedAddress;

  PaymentMode _selectedPaymentMode = PaymentMode.cod;

  final List<Map<String, String>> _suggestions = const [
    {"name": "Tata Salt Vacuum Evaporated Iodised", "qty": "1 kg", "price": "29", "old": "32"},
    {"name": "Fortune Premium Kachi Ghani Pure Mustard Oil", "qty": "910 g", "price": "194", "old": "225"},
    {"name": "Whole Farm Grocery Sugar", "qty": "1 kg", "price": "68", "old": "75"},
  ];

  @override
  void initState() {
    super.initState();
    _items = widget.items
        .map((e) => {
              ...e,
              "quantity": int.tryParse(e["quantity"] ?? "1") ?? 1,
            })
        .toList();
    _selectedAddress = _savedAddresses.first;
  }

  // ---------------- PRICE CALCULATION ----------------
  int _itemSubtotal(Map<String, dynamic> item) {
    final price = int.tryParse(item['price'].toString()) ?? 0;
    final qty = item['quantity'] as int;
    return price * qty;
  }

  int get _totalAmount => _items.fold(0, (sum, item) => sum + _itemSubtotal(item));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 140),
                child: Column(
                  children: [
                    _buildDeliveryCard(),
                    const SizedBox(height: 10),
                    _buildSuggestionsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ---------------- TOP BAR ----------------
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          Expanded(
            child: Text("Checkout",
                style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black87)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.black87),
                const SizedBox(width: 4),
                Text("Share", style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DELIVERY + CART ITEMS CARD ----------------
  Widget _buildDeliveryCard() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: appBackgroundColor, shape: BoxShape.circle),
                  child: Icon(Icons.bolt, color: appBrown, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Delivery in 22 minutes",
                        style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text("Shipment of ${_items.length} item${_items.length > 1 ? 's' : ''}",
                        style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text("Your cart is empty.", style: GoogleFonts.montserrat(color: Colors.grey)),
            )
          else
            ..._items.asMap().entries.map((entry) => _buildCartItemRow(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildCartItemRow(int index, Map<String, dynamic> item) {
    final int price = int.tryParse(item['price'].toString()) ?? 0;
    final int old = int.tryParse(item['old'].toString()) ?? 0;
    final int qty = item['quantity'] as int;
    final int subtotal = _itemSubtotal(item);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(color: appBackgroundColor.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 26)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'].toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(item['qty'].toString(), style: GoogleFonts.montserrat(fontSize: 11.5, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                // Live subtotal: price × qty = subtotal, updates on +/-
                Text(
                  "₹$price × $qty = ₹$subtotal",
                  style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600, color: appBrown),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Move to wishlist",
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 32,
                decoration: BoxDecoration(color: appOrange, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    _stepperBtn(Icons.remove, () {
                      setState(() {
                        if (qty > 1) {
                          _items[index]['quantity'] = qty - 1;
                        } else {
                          _items.removeAt(index);
                        }
                      });
                    }),
                    SizedBox(
                      width: 22,
                      child: Text(
                        "$qty",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    _stepperBtn(Icons.add, () {
                      // Tapping + increments quantity -> setState triggers
                      // _itemSubtotal() and _totalAmount to recompute and
                      // repaint automatically.
                      setState(() => _items[index]['quantity'] = qty + 1);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (old > price)
                    Text("₹$old", style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                  const SizedBox(width: 4),
                  Text("₹$price", style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.bold, color: appBrown)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(width: 26, height: 32, child: Icon(icon, size: 14, color: Colors.white)),
    );
  }

  // ---------------- SUGGESTIONS ----------------
  Widget _buildSuggestionsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("You might also like",
              style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _suggestions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 10,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) => _suggestionCard(_suggestions[index]),
          ),
        ],
      ),
    );
  }

  Widget _suggestionCard(Map<String, String> item) {
    final int price = int.tryParse(item['price'] ?? '0') ?? 0;
    final int old = int.tryParse(item['old'] ?? '0') ?? 0;
    final int discount = old > price ? (((old - price) / old) * 100).round() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(color: appBackgroundColor.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 24)),
            ),
            Positioned(top: 2, right: 2, child: Icon(Icons.favorite_border, size: 14, color: Colors.grey.shade400)),
            Positioned(
              bottom: -6,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // If already in cart, bump its quantity; else add fresh.
                    final existingIndex = _items.indexWhere((e) => e['name'] == item['name']);
                    if (existingIndex != -1) {
                      _items[existingIndex]['quantity'] = (_items[existingIndex]['quantity'] as int) + 1;
                    } else {
                      _items.add({...item, "quantity": 1});
                    }
                  });
                  CartState.addToCart({
                    "name": item['name']!,
                    "qty": item['qty']!,
                    "price": item['price']!,
                    "old": item['old']!,
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: appOrange, width: 1.2),
                  ),
                  child: Text("ADD", style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.bold, color: appOrange)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text("₹$price", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(width: 4),
            if (old > price)
              Text("₹$old", style: const TextStyle(fontSize: 9, decoration: TextDecoration.lineThrough, color: Colors.grey)),
          ],
        ),
        if (discount > 0)
          Text("$discount% OFF", style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w700, color: appOrange)),
        const SizedBox(height: 2),
        Text(
          item['name']!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ---------------- ADDRESS BOTTOM SHEET ----------------
  void _openAddressSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select delivery address",
                    style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                ..._savedAddresses.map((address) {
                  final isSelected = address == _selectedAddress;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedAddress = address);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: isSelected ? appOrange : Colors.grey.shade300, width: isSelected ? 1.6 : 1),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? appOrange.withOpacity(0.08) : Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            address.type == "Home"
                                ? Icons.home_outlined
                                : address.type == "Work"
                                    ? Icons.work_outline
                                    : Icons.location_on_outlined,
                            color: appBrown,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(address.type,
                                    style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.bold)),
                                Text(address.line,
                                    style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey.shade700)),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? appOrange : Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: navigate to your "Add new address" screen here.
                    },
                    icon: Icon(Icons.add, color: appBrown),
                    label: Text("Add new address", style: GoogleFonts.montserrat(color: appBrown, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: appBrown),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- PAYMENT MODE BOTTOM SHEET ----------------
  void _openPaymentSheet() {
    final modes = [
      PaymentMode.card,
      PaymentMode.upi,
      if (widget.isEligibleForPayLater) PaymentMode.payLater,
      PaymentMode.cod,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select payment method",
                    style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                ...modes.map((mode) {
                  final isSelected = mode == _selectedPaymentMode;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedPaymentMode = mode);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: isSelected ? appOrange : Colors.grey.shade300, width: isSelected ? 1.6 : 1),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected ? appOrange.withOpacity(0.08) : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(mode.icon, color: appBrown, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(mode.label, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600)),
                                if (mode == PaymentMode.card)
                                  Text("Axis Mastercard •••• 8970",
                                      style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey.shade600))
                                else if (mode == PaymentMode.payLater)
                                  Text("Pay within 15 days, no extra cost",
                                      style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey.shade600))
                                else if (mode == PaymentMode.upi)
                                  Text("Google Pay, PhonePe, Paytm & more",
                                      style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey.shade600))
                                else
                                  Text("Pay when your order arrives",
                                      style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? appOrange : Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- BOTTOM: ADDRESS + PAYMENT + PLACE ORDER ----------------
  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -3))],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- ADDRESS ROW (tap to change) ----
            GestureDetector(
              onTap: _openAddressSheet,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: appOrange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black87),
                              children: [
                                const TextSpan(text: "Delivering to "),
                                TextSpan(text: _selectedAddress.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: " (${_selectedAddress.type})",
                                    style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          Text(
                            _selectedAddress.line,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Text("Change",
                        style: GoogleFonts.montserrat(fontSize: 12.5, fontWeight: FontWeight.w700, color: appOrange)),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            // ---- PAYMENT ROW (tap to change) + PLACE ORDER ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _openPaymentSheet,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(color: appBackgroundColor, borderRadius: BorderRadius.circular(4)),
                                child: Icon(_selectedPaymentMode.icon, size: 14, color: appBrown),
                              ),
                              const SizedBox(width: 6),
                              Text("PAY USING",
                                  style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_up, size: 14, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(_selectedPaymentMode.label,
                              style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 170,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _items.isEmpty
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Order placed via ${_selectedPaymentMode.label}!"),
                                  backgroundColor: appBrown,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appOrange,
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("₹$_totalAmount",
                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text("TOTAL", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 8)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text("Place Order",
                              style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}