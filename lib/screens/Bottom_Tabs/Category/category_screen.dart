import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Theme Colors
  static const Color appBackgroundColor = Color(0xFFF1E4CE);
  static const Color appOrange = Color(0xFFECA369);
  static const Color appBrown = Colors.brown;

  int _selectedCategoryIndex = 0;

  // Mock Data for Categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Spices & Masala', 'icon': Icons.waves},
    {'name': 'Atta & Flours', 'icon': Icons.bakery_dining},
    {'name': 'Rice & Grains', 'icon': Icons.grass},
    {'name': 'Pulses & Dals', 'icon': Icons.grain},
    {'name': 'Oil & Ghee', 'icon': Icons.opacity},
    {'name': 'Salt & Sugar', 'icon': Icons.blur_on},
    {'name': 'Dry Fruits', 'icon': Icons.eco},
  ];

  @override
Widget build(BuildContext context) {
  return Container(
    color: appBackgroundColor,
    child: Row(
      children: [
        // LEFT CATEGORY
        _buildSideCategoryRail(),

        // RIGHT PRODUCTS
        Expanded(
          child: _buildProductGrid(),
        ),
      ],
    ),
  );
}

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      title: Text(
        "Categories",
        style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black)),
      ],
    );
  }

  Widget _buildSideCategoryRail() {
    return Container(
      width: 100,
      color: Colors.white,
      child: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? appBackgroundColor : Colors.white,
                border: Border(
                  left: BorderSide(
                    color: isSelected ? appOrange : Colors.transparent,
                    width: 4,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _categories[index]['icon'],
                    color: isSelected ? appBrown : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _categories[index]['name'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? appBrown : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-header for the selected category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _categories[_selectedCategoryIndex]['name'],
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Icon(Icons.tune, size: 18, color: appBrown), // Filter icon
            ],
          ),
          const SizedBox(height: 15),
          
          Expanded(
            child: GridView.builder(
              itemCount: 6, // Mock item count
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return _buildProductCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appBackgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Icon(Icons.image, color: Colors.grey)), // Placeholder
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Name",
                  maxLines: 1,
                  style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Text("500g", style: TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "₹149",
                      style: TextStyle(fontWeight: FontWeight.bold, color: appBrown),
                    ),
                    // Add Button
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: appOrange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}