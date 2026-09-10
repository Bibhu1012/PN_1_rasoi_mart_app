import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'package:rasoimart/screens/AppStateManagment/cart_state.dart';
import 'package:rasoimart/screens/AppStateManagment/profile_state.dart';
import 'package:rasoimart/screens/Bottom_Tabs/Category/category_screen.dart';
import 'package:rasoimart/screens/Bottom_Tabs/Order_History/order_history_screen.dart';
import 'package:rasoimart/screens/List_upload/list_upload_screen.dart';
import 'package:rasoimart/screens/My_Account/MyAccountScreen.dart';
import 'package:rasoimart/models/product_model.dart';
import 'package:rasoimart/screens/My_Cart/my_cart_screen.dart';
import 'package:rasoimart/screens/ProductDetailScreen/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isRasoiMartActive = true;
  int selectedCategoryIndex = 0;

  final PageController _adPageController1 = PageController(initialPage: 0);
  final PageController _adPageController2 = PageController(initialPage: 0);
  int _currentAdPage1 = 0;
  int _currentAdPage2 = 0;
  late Timer _adTimer;

  static const Color appBackgroundColor = Color(0xFFF1E4CE);
  static const Color appOrange = Color(0xFFECA369);
  static const Color appRed = Color(0xFFDC2626);
  static const Color appBrown = Color(0xFF6D4C2B);

  final List<Map<String, String>> categories = [
    {"name": "All", "image": "assets/images/all.png"},
    {"name": "Our Products", "image": "assets/images/our-products.png"},
    {"name": "Mustard Oil", "image": "assets/images/cooking-oil.png"},
    {"name": "Milk & Bread", "image": "assets/images/milk.png"},
    {"name": "Dry Fruits", "image": "assets/images/dry-frutes.png"},
    {"name": "Spices", "image": "assets/images/spices.png"},
    {"name": "Soap & Hand wash", "image": "assets/images/soap.png"},
    {"name": "Noodles", "image": "assets/images/noodles.png"},
    {"name": "Vegetables & Fruits", "image": "assets/images/veg.png"},
  ];

  final List<Map<String, String>> topPicksList = [
    {"name": "Sunfeast YiPPee!", "qty": "10x 30g", "price": "50", "old": "60"},
    {"name": "Maggi Noodles", "qty": "12x 70g", "price": "140", "old": "160"},
    {"name": "Fortune Oil", "qty": "1 Litre", "price": "158", "old": "180"},
    {"name": "Aashirvaad Atta", "qty": "5kg", "price": "240", "old": "280"},
  ];

  final List<Map<String, String>> rs10CornerList = [
    {"name": "Lays Classic", "qty": "20g", "price": "10", "old": "10"},
    {"name": "Parle-G", "qty": "60g", "price": "10", "old": "12"},
    {"name": "Dairy Milk", "qty": "12g", "price": "10", "old": "10"},
    {"name": "Tide Bar", "qty": "75g", "price": "10", "old": "11"},
  ];

  final List<Map<String, String>> cleanersList = [
    {"name": "Harpic Blue", "qty": "500ml", "price": "89", "old": "105"},
    {"name": "Lizol Floral", "qty": "1 Litre", "price": "199", "old": "220"},
    {"name": "Dettol Liquid", "qty": "500ml", "price": "185", "old": "210"},
    {"name": "Colin Spray", "qty": "500ml", "price": "95", "old": "110"},
  ];

  @override
  void initState() {
    super.initState();
    _adTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (mounted) {
        setState(() {
          _currentAdPage1 = (_currentAdPage1 < 4) ? _currentAdPage1 + 1 : 0;
          _currentAdPage2 = (_currentAdPage2 < 4) ? _currentAdPage2 + 1 : 0;
          if (_adPageController1.hasClients) {
            _adPageController1.animateToPage(_currentAdPage1,
                duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
          }
          if (_adPageController2.hasClients) {
            _adPageController2.animateToPage(_currentAdPage2,
                duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _adTimer.cancel();
    _adPageController1.dispose();
    _adPageController2.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature is coming soon!", style: GoogleFonts.montserrat()),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'Offers'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Order History'),
        ],
      ),
      // IMPORTANT: The shared header + search bar ONLY show on the Home tab (index 0).
      // The Category tab has its own header (built inside CategoryScreen), so we hide
      // this one when _selectedIndex == 1 to avoid a double header.
      body: SafeArea(
        child: Column(
          children: [
            if (_selectedIndex == 0) ...[
              _buildHeader(),
              _buildSearchBar(),
            ],
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildHomeTabBody(),
                  const CategoryScreen(),
                  _buildOffersTabBody(),
                  const OrderHistoryScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HOME TAB CONTENT ----------------
  Widget _buildHomeTabBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildCategoryFilterBar()),
        SliverToBoxAdapter(
          child: _buildAutoAdBanner(_adPageController1, _currentAdPage1),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildSectionHeader("Top Picks for You", subtitle: "Based on popular items"),
            _buildProductScroll(topPicksList),
            _buildSectionHeader("Shop by Category"),
            _buildCategoryGrid(),
            _buildSectionHeader("Rs. 10 Corner"),
            _buildProductScroll(rs10CornerList, badgeText: "₹10 ONLY"),
            const SizedBox(height: 6),
            _buildAutoAdBanner(_adPageController2, _currentAdPage2),
            _buildSectionHeader("Cleaners & Disinfectants", subtitle: "Hygiene Essentials"),
            _buildProductScroll(cleanersList),
            const SizedBox(height: 50),
          ]),
        ),
      ],
    );
  }

  Widget _buildOffersTabBody() {
    return Center(
      child: Text(
        "Offers coming soon!",
        style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCartScreen()),
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.shopping_cart_outlined, size: 22),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: CartState.cartCount,
                      builder: (context, count, child) {
                        if (count == 0) return const SizedBox();
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: Text(
                              "$count",
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    _toggleButton("Rasoi Mart", isRasoiMartActive, () => setState(() => isRasoiMartActive = true)),
                    _toggleButton("Stationary", !isRasoiMartActive, () => _showComingSoon("Stationary")),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyAccountScreen()),
                    ),
                    child: ProfileState.profileImage != null
                        ? CircleAvatar(radius: 16, backgroundImage: FileImage(ProfileState.profileImage!))
                        : const Icon(Icons.person_outline, size: 32),
                  ),
                  const SizedBox(height: 4),
                  Text("Delivers in", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: appRed, borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: Colors.white, size: 12),
                        Text("20 mins",
                            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          ValueListenableBuilder<Map<String, String>>(
            valueListenable: userProfileNotifier,
            builder: (context, profile, child) {
              return Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.brown),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Deliver to ${profile['location']}",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for "Grocery, Spices, Oil..."',
                  hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: const Icon(Icons.mic_none, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const ListUploadScreen(),
              );
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.assignment_outlined, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterBar() {
    return Container(
      height: 104,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          bool isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategoryIndex = index),
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [appOrange, appOrange.withOpacity(0.7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? appOrange.withOpacity(0.45) : Colors.black.withOpacity(0.05),
                          blurRadius: isSelected ? 10 : 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          categories[index]['image']!,
                          fit: BoxFit.contain,
                          color: isSelected ? Colors.white : null,
                          errorBuilder: (c, e, s) => Icon(
                            Icons.fastfood_outlined,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    categories[index]['name']!,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? appBrown : Colors.black87,
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

  Widget _buildAutoAdBanner(PageController controller, int currentPage) {
    final gradients = [
      [const Color(0xFFF6C453), const Color(0xFFE89347)],
      [const Color(0xFF7CC6A0), const Color(0xFF4E9E76)],
      [const Color(0xFFE98787), const Color(0xFFD44B4B)],
      [const Color(0xFF8EB9E8), const Color(0xFF4E80B8)],
      [const Color(0xFFC79FE0), const Color(0xFF9760C4)],
    ];
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: controller,
            itemCount: 5,
            itemBuilder: (context, index) {
              final colors = gradients[index % gradients.length];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(color: colors[1].withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(Icons.shopping_bag, size: 120, color: Colors.white.withOpacity(0.12)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Special Offer ${index + 1}",
                            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Grab it before it's gone!",
                            style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Shop Now",
                              style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.bold, color: colors[1]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentPage == index ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: currentPage == index ? appOrange : Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(color: appOrange, borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.bold, color: appBrown),
                    ),
                  ],
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 2),
                    child: Text(
                      subtitle,
                      style: GoogleFonts.montserrat(fontSize: 11.5, color: Colors.grey.shade600),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 5)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("See all", style: GoogleFonts.montserrat(fontSize: 10.5, fontWeight: FontWeight.w600, color: appOrange)),
                  const SizedBox(width: 3),
                  const Icon(Icons.arrow_forward_ios, size: 10, color: appOrange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductScroll(List<Map<String, String>> dataList, {String? badgeText}) {
    return SizedBox(
      height: 258,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataList.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) => _productCard(dataList[index], badgeText: badgeText),
      ),
    );
  }

  Widget _productCard(Map<String, String> product, {String? badgeText}) {
    final int price = int.tryParse(product['price'] ?? '0') ?? 0;
    final int old = int.tryParse(product['old'] ?? '0') ?? 0;
    final int discount = old > price ? (((old - price) / old) * 100).round() : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: Product.fromMap(
                product,
                description: "This is a premium quality ${product['name']} sourced from the best farms. It is fresh, organic and delivered straight to your doorstep.",
                nutrition: [
                  "100% Organic",
                  "Freshly Sourced",
                  "No Artificial Preservatives",
                  "Eco-friendly Packaging",
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 152,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 118,
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [appBackgroundColor.withOpacity(0.8), appBackgroundColor.withOpacity(0.3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 30)),
                ),
                if (badgeText != null)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: appRed, borderRadius: BorderRadius.circular(6)),
                      child: Text(badgeText, style: GoogleFonts.montserrat(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  )
                else if (discount > 0)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: appRed, borderRadius: BorderRadius.circular(6)),
                      child: Text("$discount% OFF", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(product['qty']!, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "₹${product['price']}",
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14, color: appBrown),
                      ),
                      if (discount > 0) ...[
                        const SizedBox(width: 5),
                        Text(
                          "₹${product['old']}",
                          style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () => CartState.addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appOrange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text("ADD", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: categories.length - 1,
      itemBuilder: (context, index) {
        var category = categories[index + 1];
        return Column(
          children: [
            Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: Icon(Icons.shopping_basket_outlined, color: appBrown.withOpacity(0.7), size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              category['name']!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(fontSize: 9.5, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        );
      },
    );
  }

  Widget _toggleButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? appOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey),
        ),
      ),
    );
  }
}