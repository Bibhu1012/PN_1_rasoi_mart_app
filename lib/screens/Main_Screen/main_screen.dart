// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rasoimart/screens/Bottom_Tabs/Category/category_screen.dart';

// import 'package:rasoimart/screens/Bottom_Tabs/Order_History/order_history_screen.dart';
// import 'package:rasoimart/screens/My_Account/MyAccountScreen.dart';
// import 'package:rasoimart/screens/My_Cart/my_cart_screen.dart';
// import 'package:rasoimart/screens/AppStateManagment/cart_state.dart';
// import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
// import 'package:rasoimart/screens/List_upload/list_upload_screen.dart';
// import 'package:rasoimart/screens/home/home_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   bool isRasoiMartActive = true;

//   static const Color appBackgroundColor = Color(0xFFF1E4CE);
//   static const Color appOrange = Color(0xFFECA369);
//   static const Color appRed = Color(0xFFDC2626);

//   final List<Widget> _screens = const [
//     HomeScreen(),
//     CategoryScreen(),
//     Center(child: Text("Offers Screen")),
//     OrderHistoryScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: appBackgroundColor,

//       // 🔻 Bottom Navigation
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 12),
//         unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 12),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
//           BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'Offers'),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Order History'),
//         ],
//       ),

//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             _buildSearchBar(),

//             // 🔥 IMPORTANT FIX
//             Expanded(
//               child: IndexedStack(
//                 index: _selectedIndex,
//                 children: _screens,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= HEADER =================
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Toggle
//               Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Row(
//                   children: [
//                     _toggleButton("Rasoi Mart", isRasoiMartActive, () {
//                       setState(() => isRasoiMartActive = true);
//                     }),
//                     _toggleButton("Stationary", !isRasoiMartActive, () {}),
//                   ],
//                 ),
//               ),

//               Row(
//                 children: [
//                   // 🛒 Cart
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const MyCartScreen()),
//                     ),
//                     child: Stack(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.shopping_cart_outlined),
//                         ),

//                         ValueListenableBuilder<int>(
//                           valueListenable: CartState.cartCount,
//                           builder: (context, count, child) {
//                             if (count == 0) return const SizedBox();
//                             return Positioned(
//                               right: 0,
//                               top: 0,
//                               child: Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.red,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Text(
//                                   "$count",
//                                   style: const TextStyle(color: Colors.white, fontSize: 10),
//                                 ),
//                               ),
//                             );
//                           },
//                         )
//                       ],
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   // Profile
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const MyAccountScreen()),
//                     ),
//                     child: const Icon(Icons.person_outline, size: 30),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           const SizedBox(height: 8),

//           // Location
//           ValueListenableBuilder<Map<String, String>>(
//             valueListenable: userProfileNotifier,
//             builder: (context, profile, child) {
//               return Row(
//                 children: [
//                   const Icon(Icons.location_on, size: 16),
//                   const SizedBox(width: 5),
//                   Expanded(
//                     child: Text(
//                       "Deliver to ${profile['location']}",
//                       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= SEARCH =================
//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search",
//                   border: InputBorder.none,
//                   prefixIcon: Icon(Icons.search),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 builder: (_) => const ListUploadScreen(),
//               );
//             },
//             child: Container(
//               height: 45,
//               width: 45,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(Icons.assignment_outlined),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _toggleButton(String text, bool isActive, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//         decoration: BoxDecoration(
//           color: isActive ? appOrange : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           text,
//           style: GoogleFonts.montserrat(
//             fontWeight: FontWeight.bold,
//             color: isActive ? Colors.black : Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/Bottom_Tabs/Home/home_screen.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'package:rasoimart/screens/AppStateManagment/cart_state.dart';
import 'package:rasoimart/screens/List_upload/list_upload_screen.dart';
import 'package:rasoimart/screens/My_Account/MyAccountScreen.dart';
import 'package:rasoimart/screens/My_Cart/my_cart_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isRasoiMartActive = true;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text("Category Screen")),
    const Center(child: Text("Offers Screen")),
    const Center(child: Text("Order History Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      body: SafeArea(
        child: Column(
          children: [
            _buildPersistentHeader(),
            _buildPersistentSearchBar(),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: 'Offers'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }

  Widget _buildPersistentHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  builder: (context, count, _) => count == 0 ? const SizedBox() : Positioned(
                    right: 0, top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text("$count", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
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
                _toggleButton("Stationary", !isRasoiMartActive, () {}),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAccountScreen())),
            child: const Icon(Icons.person_outline, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildPersistentSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
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
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const ListUploadScreen()),
            child: Container(
              height: 50, width: 50,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
              child: const Icon(Icons.assignment_outlined, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(color: isActive ? const Color(0xFFECA369) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey)),
      ),
    );
  }
}