import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/cart_state.dart';
import 'package:rasoimart/screens/Bottom_Tabs/Category/All_Categoties/category_models.dart';
import 'category_models.dart';

class CategoryDetailScreen extends StatefulWidget {
  final MainCategoryItem category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  static const Color appOrange = Color(0xFFECA369);
  int? _selectedSubCategoryIndex;
  final Map<String, int> _quantities = {};

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildBanner(category)),
            SliverToBoxAdapter(child: _buildSubCategoryGrid(category)),
            SliverToBoxAdapter(child: _buildPromoBanner()),
            SliverToBoxAdapter(child: _buildBestsellersHeader()),
            SliverToBoxAdapter(child: _buildProductList(category)),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(MainCategoryItem category) {
    return Container(
      height: 190,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [category.accentColor, category.accentColor.withOpacity(0.65)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(category.icon, size: 150, color: Colors.white.withOpacity(0.12)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleIconButton(Icons.arrow_back, () => Navigator.pop(context)),
                  _circleIconButton(Icons.search, () {}),
                ],
              ),
              const Spacer(),
              Text(
                category.name.toUpperCase(),
                style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildSubCategoryGrid(MainCategoryItem category) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 6),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: category.subCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.82,
        ),
        itemBuilder: (context, index) {
          bool isSelected = _selectedSubCategoryIndex == index;
          final sub = category.subCategories[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedSubCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: category.accentColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? category.accentColor : category.accentColor.withOpacity(0.25),
                  width: isSelected ? 1.6 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(sub.icon, size: 22, color: category.accentColor),
                  const SizedBox(height: 6),
                  Text(
                    sub.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black87, height: 1.15),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF3A6B4C), Color(0xFF6FA37E)], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13),
                    children: const [
                      TextSpan(text: "Save up to "),
                      TextSpan(text: "5%", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " on every order"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    "APPLY NOW",
                    style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF3A6B4C)),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.local_offer, color: Colors.white, size: 36),
        ],
      ),
    );
  }

  Widget _buildBestsellersHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("BESTSELLERS", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(MainCategoryItem category) {
    if (category.bestsellers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text("No products yet in this category.", style: GoogleFonts.montserrat(color: Colors.grey)),
      );
    }
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: category.bestsellers.length,
        itemBuilder: (context, index) => _buildProductCard(category.bestsellers[index]),
      ),
    );
  }

  Widget _buildProductCard(ProductItem product) {
    final key = "${product.brand}_${product.name}";
    final int quantity = _quantities[key] ?? 0;

    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 14),
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
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 28)),
              ),
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(border: Border.all(color: product.isVeg ? Colors.green : Colors.red, width: 1.2)),
                  child: Icon(Icons.circle, size: 6, color: product.isVeg ? Colors.green : Colors.red),
                ),
              ),
              Positioned(top: 2, right: 2, child: Icon(Icons.favorite_border, size: 16, color: Colors.grey.shade400)),
              Positioned(
                bottom: -8,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _quantities[key] = quantity + 1);
                    CartState.addToCart({
                      'name': product.name,
                      'qty': product.qty,
                      'price': product.price.toString(),
                      'old': product.oldPrice.toString(),
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: appOrange, width: 1.2),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)],
                    ),
                    child: Icon(Icons.add, size: 14, color: appOrange),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (product.discountPercent > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              color: const Color(0xFFFFD814),
              child: Text("${product.discountPercent}% OFF", style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("₹${product.price}", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 5),
              if (product.oldPrice > product.price)
                Text("₹${product.oldPrice}", style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: Colors.grey)),
            ],
          ),
          Text(product.brand.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Text(product.qty, style: GoogleFonts.montserrat(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF3A6B4C))),
              const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF3A6B4C)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.bolt, size: 12, color: appOrange),
              const SizedBox(width: 2),
              Text(product.deliveryTime, style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }
}