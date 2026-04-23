import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // App Theme Colors
  static const Color backgroundColor = Color(0xFFF1E4CE);
  static const Color primaryBrown = Color(0xFF6D4C41);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Notifications",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            indicatorColor: primaryBrown,
            indicatorWeight: 3,
            labelColor: primaryBrown,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Alerts"),
              Tab(text: "Offers"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAlertsTab(),
            _buildOffersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsTab() {
    // Example data for Alerts
    final alerts = [
      {
        'title': 'Order Delivered!',
        'desc': 'Your order #RM1024 has been delivered successfully.',
        'time': '2 mins ago',
        'icon': Icons.check_circle_outline,
        'isUnread': true,
      },
      {
        'title': 'Credit Approved',
        'desc': 'Your request for ₹15,000 credit limit is now active.',
        'time': '1 hour ago',
        'icon': Icons.account_balance_wallet_outlined,
        'isUnread': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _notificationCard(
          title: alert['title'] as String,
          desc: alert['desc'] as String,
          time: alert['time'] as String,
          icon: alert['icon'] as IconData,
          isUnread: alert['isUnread'] as bool,
          iconColor: Colors.blueAccent,
        );
      },
    );
  }

  Widget _buildOffersTab() {
    // Example data for Offers
    final offers = [
      {
        'title': 'Weekend Special!',
        'desc': 'Get 20% off on all organic spices this weekend. Use code: SPICE20',
        'time': 'Today',
        'icon': Icons.local_offer_outlined,
        'isUnread': true,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return _notificationCard(
          title: offer['title'] as String,
          desc: offer['desc'] as String,
          time: offer['time'] as String,
          icon: offer['icon'] as IconData,
          isUnread: offer['isUnread'] as bool,
          iconColor: Colors.orange,
        );
      },
    );
  }

  Widget _notificationCard({
    required String title,
    required String desc,
    required String time,
    required IconData icon,
    required bool isUnread,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Section
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          // Content Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    if (isUnread)
                      const CircleAvatar(radius: 4, backgroundColor: Colors.red),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}