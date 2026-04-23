import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this is in your pubspec.yaml

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I track my spice order?',
      'answer': 'You can track your order in the "My Orders" section. A tracking link will also be sent via SMS once dispatched.'
    },
    {
      'question': 'Are RasoiMart spices organic?',
      'answer': 'Yes, all our spices are sourced directly from farms and are 100% pure without any added colors or preservatives.'
    },
    {
      'question': 'What is the return policy?',
      'answer': 'We offer a 7-day return policy for unopened packages if the product is damaged or incorrect.'
    },
    {
      'question': 'Do you offer bulk/wholesale pricing?',
      'answer': 'Yes! For bulk inquiries, please contact us via the "Call Us" button or email us at support@rasoimart.com.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, currentLang, child) {
        final words = translations[currentLang]!;

        return Scaffold(
          backgroundColor: const Color(0xFFF1E4CE),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              words['help_support'] ?? "Help & Support",
              style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                _buildContactGrid(),
                const SizedBox(height: 30),
                Text(
                  "Frequently Asked Questions",
                  style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown.shade900),
                ),
                const SizedBox(height: 15),
                _buildFAQList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.support_agent, color: Colors.white, size: 50),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("How can we help you?", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("Our team is available 9 AM - 8 PM", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _buildContactCard(Icons.chat_bubble_outline, "Live Chat", Colors.blue, () {}),
        _buildContactCard(Icons.phone_in_talk_outlined, "Call Us", Colors.green, () => _launchURL("tel:+919939963986")),
        _buildContactCard(Icons.email_outlined, "Email", Colors.orange, () => _launchURL("mailto:support@rasoimart.com")),
        _buildContactCard(Icons.location_on_outlined, "Office", Colors.red, () {}),
      ],
    );
  }

  Widget _buildContactCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQList() {
    return Column(
      children: faqs.map((faq) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            title: Text(faq['question']!, style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(faq['answer']!, style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}