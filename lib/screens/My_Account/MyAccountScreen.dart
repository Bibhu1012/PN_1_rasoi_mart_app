import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'package:rasoimart/screens/My_Account/Address/address_screen.dart';
import 'package:rasoimart/screens/My_Account/Credit/credit_screen.dart';
import 'package:rasoimart/screens/My_Account/Edit_profile/edit_profile_screen.dart';
import 'package:rasoimart/screens/My_Account/Notification/notification_screen.dart';
import 'package:rasoimart/screens/My_Account/Order/order_screen.dart';
import 'package:rasoimart/screens/My_Account/Rating&Reviews/ratings_reviews_screen.dart';
import 'package:rasoimart/screens/My_Account/Save_for_Later/save_for_later_screen.dart';
import 'package:rasoimart/screens/My_Account/Saved_Payments/saved_payments_screen.dart';
import 'package:rasoimart/screens/My_Account/Support/help_support_screen.dart';
import 'package:rasoimart/screens/My_Account/Update_Profile/update_profile_screen.dart';
import 'package:rasoimart/screens/My_Account/language/language_screen.dart';
import 'package:rasoimart/screens/Bottom_Tabs/Order_History/order_history_screen.dart';
// import 'package:rasoimart/screens/My_Account/language_screen.dart';
import 'app_state.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  Map<String, String> userData = {
    'name': 'BIBHANSHU GUPTA',
    'phone': '9939963986',
    'email': 'bgupta535@hotmail.com',
  };

  String creditStatus = 'active'; 
  double creditLimit = 20000.0;

  static const Color backgroundColor = Color(0xFFF1E4CE);
  static const Color cardColor = Color(0xFFE5D5B8);
  static const Color iconBgColor = Color(0xFFD9CCB3);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final words = translations[currentLang]!;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              words['my_account']!,
              style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileCard(context),
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _quickActionItem(
                      Icons.assignment_outlined, 
                      words['orders'] ?? "Orders", 
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()))
                    ),
//                     _quickActionItem(
//   Icons.assignment_outlined, 
//   words['orders'] ?? "Orders", 
//   // Update the class name to OrderHistoryScreen
//   () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen()))
// ),
                    _quickActionItem(
                      Icons.credit_card, 
                      creditStatus == 'active' ? "₹${creditLimit.toInt()}" : "Credit", 
                      _handleCreditRequest
                    ),
                    _quickActionItem(
                      Icons.location_on_outlined, 
                      words['address'] ?? "Address", 
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressScreen()))
                    ),
                  ],
                ),

                const Divider(height: 40, thickness: 1, indent: 20, endIndent: 20),

                _buildAccountOption(Icons.notifications_none, words['notifications']!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()))),
                _buildAccountOption(Icons.bookmark_border, words['save_later']!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SaveForLaterScreen()))),
                _buildAccountOption(Icons.account_balance_wallet_outlined, words['saved_payments'] !, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedPaymentsScreen())),),
                _buildAccountOption(Icons.language_outlined, words['language']!, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageScreen()))),
                _buildAccountOption(Icons.star_border, words['ratings'] !, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RatingsReviewsScreen())),),
                _buildAccountOption(Icons.headset_mic_outlined, words['support'] !, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen())),),

                const SizedBox(height: 30),
                _buildInfoLink("FAQs"),
                _buildInfoLink("Terms & Conditions"),
                _buildInfoLink("Privacy Policy"),
                const SizedBox(height: 40),
                _buildFooter(), // Updated footer with custom colors
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleCreditRequest() {
    if (creditStatus == 'active') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const CreditScreen()));
    }
  }

  Widget _buildProfileCard(BuildContext context) {
  // Wrap everything in the builder to "listen" for global state changes
  return ValueListenableBuilder<Map<String, String>>(
    valueListenable: userProfileNotifier,
    builder: (context, profile, child) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor, // Ensure cardColor is defined in your class
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.person, size: 30, color: Colors.black54),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use 'profile' from the builder instead of 'userData'
                  Text(
                    profile['name'] ?? "User Name", 
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  Text(
                    profile['phone'] ?? "Phone Number", 
                    style: GoogleFonts.montserrat(fontSize: 12)
                  ),
                  Text(
                    profile['email'] ?? "Email Address", 
                    style: GoogleFonts.montserrat(fontSize: 12)
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_note, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

  Widget _quickActionItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAccountOption(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 26, color: Colors.black87),
            const SizedBox(width: 20),
            Expanded(child: Text(title, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500))),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoLink(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(text, style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey.shade600)),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Text("Log Out", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
          label: const Icon(Icons.logout, color: Colors.blue),
        ),
        const SizedBox(height: 20),
        // Social Media Icons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 18, backgroundColor: Colors.pink, child: Icon(Icons.circle, color: Colors.white, size: 10)),
            const SizedBox(width: 20),
            const CircleAvatar(radius: 18, backgroundColor: Colors.blue, child: Icon(Icons.circle, color: Colors.white, size: 10)),
            const SizedBox(width: 20),
            const CircleAvatar(radius: 18, backgroundColor: Colors.black, child: Icon(Icons.circle, color: Colors.white, size: 10)),
          ],
        ),
        const SizedBox(height: 20),
        // Logo with RM prefix
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 194, 182),
                borderRadius: BorderRadius.circular(4),
              ),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: "R", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                    TextSpan(text: "M", style: TextStyle(color: Color(0xFF795548), fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 5),
            RichText(
              text: TextSpan(
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20),
                children: const [
                  TextSpan(text: "Rasoi", style: TextStyle(color: Colors.red)),
                  TextSpan(text: "Mart", style: TextStyle(color: Color(0xFF795548))),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text("v1.0.0", style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}