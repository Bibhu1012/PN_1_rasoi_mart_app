import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'package:rasoimart/screens/AppStateManagment/cart_state.dart';
import 'package:rasoimart/screens/Bottom_Tabs/Order_History/order_history_screen.dart';
import 'package:rasoimart/screens/List_upload/list_upload_screen.dart';
import 'package:rasoimart/screens/My_Account/MyAccountScreen.dart';
import 'package:rasoimart/screens/My_Cart/my_cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isRasoiMartActive = true;
  int selectedCategoryIndex = 0;

  // Ad Slider Logic
  final PageController _adPageController1 = PageController(initialPage: 0);
  final PageController _adPageController2 = PageController(initialPage: 0);
  int _currentAdPage1 = 0;
  int _currentAdPage2 = 0;
  late Timer _adTimer;

  static const Color appBackgroundColor = Color(0xFFF1E4CE);
  static const Color appOrange = Color(0xFFECA369);
  static const Color appRed = Color(0xFFDC2626);
  static const Color priceYellow = Color(0xFFFFD700); 
  static const Color quantityGrey = Color(0xFFE0E0E0); 

  // --- UNIQUE DATA LISTS ---
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
            _adPageController1.animateToPage(_currentAdPage1, duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
          }
          if (_adPageController2.hasClients) {
            _adPageController2.animateToPage(_currentAdPage2, duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
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

  // Helper to handle Bottom Nav Navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen()));
      setState(() => _selectedIndex = 0); // Reset home as active after returning
    }
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            _buildSearchBar(),
            SliverToBoxAdapter(child: _buildCategoryFilterBar()),
            SliverToBoxAdapter(child: _buildAutoAdBanner(_adPageController1, _currentAdPage1)),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader("Top Picks for You", subtitle: "Based on popular items"),
                _buildProductScroll(topPicksList),
                _buildSectionHeader("Shop by Category"),
                _buildCategoryGrid(),
                _buildSectionHeader("Rs. 10 Corner"),
                _buildProductScroll(rs10CornerList),
                const SizedBox(height: 10),
                _buildAutoAdBanner(_adPageController2, _currentAdPage2),
                _buildSectionHeader("Cleaners & Disinfectants", subtitle: "Hygiene Essentials"),
                _buildProductScroll(cleanersList),
                const SizedBox(height: 50),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCartScreen())),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
                        child: const Icon(Icons.shopping_cart_outlined, size: 26),
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: CartState.cartCount,
                        builder: (context, count, child) {
                          if (count == 0) return const SizedBox();
                          return Positioned(
                            right: 0, top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: Text("$count", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAccountScreen())),
                      child: const Icon(Icons.person_outline, size: 32),
                    ),
                    const SizedBox(height: 4),
                    Text("Delivers in", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w500)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: appRed, borderRadius: BorderRadius.circular(5)),
                      child: Row(children: [
                        const Icon(Icons.bolt, color: Colors.white, size: 12),
                        Text("20 mins", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // DYNAMIC ADDRESS SECTION
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
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: appBackgroundColor,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for "Masala"',
                  hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: const Icon(Icons.mic_none, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
  onTap: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take full height
      backgroundColor: Colors.transparent, // Required for custom rounded corners
      builder: (context) => const ListUploadScreen(),
    );
  },
  child: Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(Icons.assignment_outlined, color: Colors.black),
  ),
),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterBar() {
    return Container(
      height: 110,
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
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 1 ? appOrange.withOpacity(0.3) : Colors.white,
                      border: Border.all(color: isSelected ? appOrange : Colors.grey.shade200, width: isSelected ? 2 : 1),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(categories[index]['image']!, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.fastfood_outlined, color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(categories[index]['name']!, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                  if (isSelected) Container(height: 2.5, width: 25, color: Colors.black, margin: const EdgeInsets.only(top: 2)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAutoAdBanner(PageController controller, int currentPage) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: controller,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.brown.shade100),
                child: Center(child: Text("Special Offer ${index + 1}", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.brown))),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: currentPage == index ? 20 : 8, height: 8,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: currentPage == index ? appOrange : Colors.grey.shade400),
          )),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
              if (subtitle != null) Text(subtitle, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: appOrange),
        ],
      ),
    );
  }

  Widget _buildProductScroll(List<Map<String, String>> dataList) {
    return SizedBox(
      height: 250, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataList.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) => _productCard(dataList[index]),
      ),
    );
  }

  Widget _productCard(Map<String, String> product) {
    return Container(
      width: 150, 
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: const Center(child: Icon(Icons.image, color: Colors.grey)),
          ),
          const SizedBox(height: 8),
          Text(product['name']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(product['qty']!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("₹${product['price']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(width: 5),
              Text("₹${product['old']}", style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => CartState.addToCart(product),
            style: ElevatedButton.styleFrom(backgroundColor: appOrange, minimumSize: const Size(double.infinity, 30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text("ADD", style: TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 0.7),
      itemCount: categories.length - 1, 
      itemBuilder: (context, index) {
        var category = categories[index + 1]; 
        return Column(
          children: [
            Container(
              height: 70, width: 70,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: const Icon(Icons.shopping_basket_outlined, color: Colors.brown),
            ),
            const SizedBox(height: 4),
            Text(category['name']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }

  Widget _toggleButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(color: isActive ? appOrange : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rasoimart/screens/AppStateManagment/cart_state.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int selectedCategoryIndex = 0;
//   final PageController _adPageController1 = PageController();
//   final PageController _adPageController2 = PageController();
//   int _currentAdPage1 = 0;
//   int _currentAdPage2 = 0;
//   late Timer _adTimer;

//   static const Color appOrange = Color(0xFFECA369);

//   final List<Map<String, String>> categories = [
//     {"name": "All", "image": "assets/images/all.png"},
//     {"name": "Our Products", "image": "assets/images/our-products.png"},
//     {"name": "Mustard Oil", "image": "assets/images/cooking-oil.png"},
//     {"name": "Milk & Bread", "image": "assets/images/milk.png"},
//     {"name": "Dry Fruits", "image": "assets/images/dry-frutes.png"},
//     {"name": "Spices", "image": "assets/images/spices.png"},
//     {"name": "Soap & Hand wash", "image": "assets/images/soap.png"},
//     {"name": "Noodles", "image": "assets/images/noodles.png"},
//     {"name": "Vegetables & Fruits", "image": "assets/images/veg.png"},
//   ];

//   final List<Map<String, String>> topPicksList = [
//     {"name": "Sunfeast YiPPee!", "qty": "10x 30g", "price": "50", "old": "60"},
//     {"name": "Maggi Noodles", "qty": "12x 70g", "price": "140", "old": "160"},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _adTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
//       if (mounted) {
//         setState(() {
//           _currentAdPage1 = (_currentAdPage1 < 4) ? _currentAdPage1 + 1 : 0;
//           _currentAdPage2 = (_currentAdPage2 < 4) ? _currentAdPage2 + 1 : 0;
//           if (_adPageController1.hasClients) _adPageController1.animateToPage(_currentAdPage1, duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
//           if (_adPageController2.hasClients) _adPageController2.animateToPage(_currentAdPage2, duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _adTimer.cancel();
//     _adPageController1.dispose();
//     _adPageController2.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(child: _buildCategoryFilterBar()),
//           SliverToBoxAdapter(child: _buildAutoAdBanner(_adPageController1, _currentAdPage1)),
//           SliverList(
//             delegate: SliverChildListDelegate([
//               _buildSectionHeader("Top Picks for You", subtitle: "Based on popular items"),
//               _buildProductScroll(topPicksList),
//               _buildSectionHeader("Shop by Category"),
//               _buildCategoryGrid(),
//               const SizedBox(height: 50),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryFilterBar() {
//     return Container(
//       height: 110,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         padding: const EdgeInsets.only(left: 16),
//         itemBuilder: (context, index) {
//           bool isSelected = selectedCategoryIndex == index;
//           return GestureDetector(
//             onTap: () => setState(() => selectedCategoryIndex = index),
//             child: Padding(
//               padding: const EdgeInsets.only(right: 15),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 60, height: 60,
//                     decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: isSelected ? appOrange : Colors.grey.shade200, width: isSelected ? 2 : 1)),
//                     child: const Icon(Icons.fastfood_outlined, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(categories[index]['name']!, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildAutoAdBanner(PageController controller, int currentPage) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 180,
//           child: PageView.builder(
//             controller: controller,
//             itemCount: 5,
//             itemBuilder: (context, index) => Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.brown.shade100),
//               child: Center(child: Text("Special Offer ${index + 1}", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionHeader(String title, {String? subtitle}) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 25, 16, 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(title, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (subtitle != null) Text(subtitle, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)),
//           ]),
//           const Icon(Icons.arrow_forward_ios, size: 16, color: appOrange),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductScroll(List<Map<String, String>> dataList) {
//     return SizedBox(
//       height: 220,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: dataList.length,
//         padding: const EdgeInsets.only(left: 16),
//         itemBuilder: (context, index) => _productCard(dataList[index]),
//       ),
//     );
//   }

//   Widget _productCard(Map<String, String> product) {
//     return Container(
//       width: 140,
//       margin: const EdgeInsets.only(right: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)), child: const Center(child: Icon(Icons.image, color: Colors.grey))),
//           Text(product['name']!, style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1),
//           Text("₹${product['price']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
//           ElevatedButton(onPressed: () => CartState.addToCart(product), style: ElevatedButton.styleFrom(backgroundColor: appOrange), child: const Text("ADD")),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryGrid() {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 15, crossAxisSpacing: 15),
//       itemCount: categories.length - 1,
//       itemBuilder: (context, index) => Column(
//         children: [
//           Container(height: 60, width: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.shopping_basket_outlined)),
//           Text(categories[index + 1]['name']!, style: const TextStyle(fontSize: 9), textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }
// }
