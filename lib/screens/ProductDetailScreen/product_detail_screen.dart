import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/models/product_model.dart';
import 'package:rasoimart/screens/AppStateManagment/cart_state.dart';
import 'package:rasoimart/screens/Checkout/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const Color appBackgroundColor = Color(0xFFF1E4CE);
  static const Color appOrange = Color(0xFFECA369);
  static const Color appRed = Color(0xFFDC2626);
  static const Color appBrown = Color(0xFF6D4C2B);

  int _selectedUnitIndex = 0;
  int quantity = 0; // 0 = not added yet, shows ADD button
  bool isFavorite = false;

  // ---- Placeholder "Similar products" data. Replace with real data source
  // (e.g. same-category products) once available. ----
  final List<Map<String, String>> _similarProducts = const [
    {"name": "Aashirvaad Shudh Chakki Atta (5kg)", "qty": "5 kg", "price": "243", "old": "278"},
    {"name": "Aashirvaad High Protein Atta", "qty": "5 kg", "price": "328", "old": "393"},
    {"name": "Aashirvaad Low GI Sugar Control Atta", "qty": "5 kg", "price": "476", "old": "540"},
  ];

  bool get _hasUnits => widget.product.hasMultipleUnits;

  // Effective price/old-price/stock based on selected unit (or product defaults)
  double get _price => _hasUnits
      ? widget.product.units[_selectedUnitIndex].price
      : (double.tryParse(widget.product.price) ?? 0);

  double get _oldPrice => _hasUnits
      ? widget.product.units[_selectedUnitIndex].oldPrice
      : (double.tryParse(widget.product.oldPrice) ?? 0);

  String get _unitLabel =>
      _hasUnits ? widget.product.units[_selectedUnitIndex].label : widget.product.qty;

  int get _discount => _oldPrice > _price ? (((_oldPrice - _price) / _oldPrice) * 100).round() : 0;

  void _addToCart() {
    setState(() => quantity = 1);
    CartState.addToCart({
      "name": widget.product.name,
      "qty": _unitLabel,
      "price": _price.toStringAsFixed(0),
      "old": _oldPrice.toStringAsFixed(0),
    });
  }

  void _increment() {
    setState(() => quantity++);
    CartState.addToCart({
      "name": widget.product.name,
      "qty": _unitLabel,
      "price": _price.toStringAsFixed(0),
      "old": _oldPrice.toStringAsFixed(0),
    });
  }

  void _decrement() {
    setState(() => quantity = quantity > 1 ? quantity - 1 : 0);
    // Note: this only adjusts local UI count. If you want removal to also
    // reduce CartState's stored quantity, add a CartState.removeOne(...)
    // method once you share cart_state.dart.
  }

  void _goToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          items: [
            {
              "name": widget.product.name,
              "qty": _unitLabel,
              "price": _price.toStringAsFixed(0),
              "old": _oldPrice.toStringAsFixed(0),
              "quantity": quantity.toString(),
            },
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeroBanner(product),
              SliverToBoxAdapter(child: _buildInfoChipsRow(product)),
              SliverToBoxAdapter(child: _buildTitleAndRatingCard(product)),
              if (_hasUnits) SliverToBoxAdapter(child: _buildUnitSelector(product)),
              SliverToBoxAdapter(child: _buildBrandStrip(product)),
              SliverToBoxAdapter(child: _buildReplacementStrip()),
              SliverToBoxAdapter(child: _buildAboutSection(product)),
              SliverToBoxAdapter(child: _buildSimilarProductsHeader()),
              SliverToBoxAdapter(child: _buildSimilarProductsScroll()),
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),
          _buildViewCartPill(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ---------------- HERO BANNER ----------------
  Widget _buildHeroBanner(Product product) {
    final hasTagline = product.tagline.isNotEmpty;
    return SliverAppBar(
      expandedHeight: hasTagline ? 340 : 260,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: appBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [appBrown.withOpacity(0.85), appOrange.withOpacity(0.55)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            if (hasTagline)
              Positioned(
                top: 40,
                left: 16,
                right: 16,
                child: Text(
                  product.tagline,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.35),
                    height: 1.1,
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: hasTagline ? 60 : 0, left: 40, right: 40, bottom: 20),
                child: Image.asset(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.image_outlined, size: 120, color: Colors.white70),
                ),
              ),
            ),
            // Top icon row
            Positioned(
              top: 6,
              left: 8,
              right: 8,
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleIcon(Icons.keyboard_arrow_down, () => Navigator.pop(context)),
                    Row(
                      children: [
                        _circleIcon(isFavorite ? Icons.favorite : Icons.favorite_border,
                            () => setState(() => isFavorite = !isFavorite),
                            color: isFavorite ? appRed : Colors.black87),
                        const SizedBox(width: 8),
                        _circleIcon(Icons.search, () {}),
                        const SizedBox(width: 8),
                        _circleIcon(Icons.ios_share, () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap, {Color color = Colors.black87}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  // ---------------- CALORIE / PROTEIN CHIPS ----------------
  Widget _buildInfoChipsRow(Product product) {
    if (product.calorieContent == null && product.proteinContent == null) {
      return const SizedBox();
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          if (product.calorieContent != null)
            Expanded(child: _infoChip("Calorie Content", product.calorieContent!)),
          if (product.calorieContent != null && product.proteinContent != null)
            const SizedBox(width: 10),
          if (product.proteinContent != null)
            Expanded(child: _infoChip("Protein Content", product.proteinContent!)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: appBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: appOrange),
              ),
              child: Text(
                "View\ndetails",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w700, color: appBrown, height: 1.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFF6F6F6), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey.shade600)),
          const SizedBox(height: 3),
          Text(value, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87)),
        ],
      ),
    );
  }

  // ---------------- TITLE + RATING CARD ----------------
  Widget _buildTitleAndRatingCard(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(product.deliveryTime, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey.shade700)),
              const SizedBox(width: 10),
              const Text("|", style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 10),
              Icon(Icons.star, size: 14, color: Colors.amber.shade700),
              const SizedBox(width: 3),
              Icon(Icons.star, size: 14, color: Colors.amber.shade700),
              const SizedBox(width: 3),
              Icon(Icons.star, size: 14, color: Colors.amber.shade700),
              const SizedBox(width: 3),
              Icon(Icons.star, size: 14, color: Colors.amber.shade700),
              const SizedBox(width: 3),
              Icon(Icons.star_half, size: 14, color: Colors.amber.shade700),
              const SizedBox(width: 5),
              Text(product.ratingCount, style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey.shade700)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: appBrown, height: 1.3),
          ),
          if (product.stockLeft > 0 && product.stockLeft <= 10) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (product.stockLeft / 10).clamp(0.1, 1.0),
                    child: Container(
                      decoration: BoxDecoration(color: appOrange, borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text("${product.stockLeft} left", style: GoogleFonts.montserrat(fontSize: 11.5, color: Colors.grey.shade700)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------------- UNIT SELECTOR ----------------
  Widget _buildUnitSelector(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Unit", style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(product.units.length, (index) {
              final unit = product.units[index];
              final isSelected = _selectedUnitIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedUnitIndex = index;
                    quantity = 0; // reset qty display when switching pack size
                  }),
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? appOrange.withOpacity(0.12) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? appOrange : Colors.grey.shade300, width: isSelected ? 1.6 : 1),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(unit.label, style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text("₹${unit.price.toStringAsFixed(0)}",
                                    style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: appBrown)),
                                const SizedBox(width: 4),
                                Text("MRP", style: GoogleFonts.montserrat(fontSize: 9, color: Colors.grey.shade600)),
                                const SizedBox(width: 2),
                                Text("₹${unit.oldPrice.toStringAsFixed(0)}",
                                    style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                              ],
                            ),
                            if (unit.discountPercent > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  "${unit.discountPercent}% OFF on MRP",
                                  style: GoogleFonts.montserrat(fontSize: 10.5, fontWeight: FontWeight.w700, color: appOrange),
                                ),
                              ),
                            const SizedBox(height: 3),
                            Text("₹${unit.pricePerKg.toStringAsFixed(1)}/kg",
                                style: GoogleFonts.montserrat(fontSize: 9.5, color: Colors.grey.shade600)),
                          ],
                        ),
                        if (isSelected && quantity > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: appOrange, shape: BoxShape.circle),
                              child: Text(
                                "$quantity",
                                style: GoogleFonts.montserrat(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ---------------- BRAND STRIP ----------------
  Widget _buildBrandStrip(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: appBackgroundColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.storefront, color: appBrown, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.brand, style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700)),
                    Text("Explore all products",
                        style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- REPLACEMENT STRIP ----------------
  Widget _buildReplacementStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(Icons.published_with_changes, color: appBrown, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text("72 hours only replacement",
                  style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ---------------- ABOUT SECTION ----------------
  Widget _buildAboutSection(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About this product",
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(product.description, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black87, height: 1.5)),
          const SizedBox(height: 16),
          Text("Key Features",
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 10),
          ...product.nutritionInfo.map((info) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: appOrange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(info, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black87))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ---------------- SIMILAR PRODUCTS ----------------
  Widget _buildSimilarProductsHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Text("Similar products",
          style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildSimilarProductsScroll() {
    return Container(
      color: Colors.white,
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: _similarProducts.length,
        itemBuilder: (context, index) => _similarProductCard(_similarProducts[index]),
      ),
    );
  }

  Widget _similarProductCard(Map<String, String> item) {
    final int price = int.tryParse(item['price'] ?? '0') ?? 0;
    final int old = int.tryParse(item['old'] ?? '0') ?? 0;
    final int discount = old > price ? (((old - price) / old) * 100).round() : 0;

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 14, bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(color: appBackgroundColor.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 26)),
              ),
              Positioned(top: 2, right: 2, child: Icon(Icons.favorite_border, size: 15, color: Colors.grey.shade400)),
              Positioned(
                bottom: -6,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    CartState.addToCart({
                      "name": item['name']!,
                      "qty": item['qty']!,
                      "price": item['price']!,
                      "old": item['old']!,
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: appOrange, width: 1.2),
                    ),
                    child: Text("ADD", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: appOrange)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (discount > 0)
            Text("$discount% OFF on MRP",
                style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w700, color: appOrange)),
          const SizedBox(height: 2),
          Row(
            children: [
              Text("₹$price", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(width: 4),
              if (old > price)
                Text("₹$old", style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            item['name']!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ---------------- FLOATING "VIEW CART" PILL ----------------
  Widget _buildViewCartPill() {
    if (quantity == 0) return const SizedBox();
    return Positioned(
      bottom: 96,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: _goToCheckout,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: appBrown,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.shopping_bag, size: 16, color: Color(0xFF6D4C2B)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("View cart",
                          style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("$quantity Item${quantity > 1 ? 's' : ''}",
                          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- BOTTOM ACTION BAR ----------------
  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -3))],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_unitLabel, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey.shade600)),
                    Row(
                      children: [
                        Text("₹${_price.toStringAsFixed(0)}",
                            style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: appBrown)),
                        if (_discount > 0) ...[
                          const SizedBox(width: 6),
                          Text("MRP ₹${_oldPrice.toStringAsFixed(0)}",
                              style: const TextStyle(fontSize: 11, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        ],
                      ],
                    ),
                    Text("Inclusive of all taxes", style: GoogleFonts.montserrat(fontSize: 9.5, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              quantity == 0
                  ? SizedBox(
                      width: 130,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appOrange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Add to cart",
                            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    )
                  : Container(
                      height: 44,
                      decoration: BoxDecoration(color: appOrange, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          IconButton(onPressed: _decrement, icon: const Icon(Icons.remove, color: Colors.white, size: 18)),
                          Text("$quantity",
                              style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          IconButton(onPressed: _increment, icon: const Icon(Icons.add, color: Colors.white, size: 18)),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}