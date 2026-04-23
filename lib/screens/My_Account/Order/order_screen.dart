import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  static const Color backgroundColor = Color(0xFFF1E4CE);

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
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("My Orders", style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold)),
          bottom: TabBar(
            indicatorColor: Colors.brown,
            labelColor: Colors.brown,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            tabs: const [Tab(text: "Active"), Tab(text: "Past Orders")],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(isActive: true),
            _buildOrderList(isActive: false),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList({required bool isActive}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order #RM102${index + 4}", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
                Text(isActive ? "On the way" : "Delivered", 
                    style: GoogleFonts.montserrat(color: isActive ? Colors.orange : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(width: 50, height: 50, color: backgroundColor, child: const Icon(Icons.shopping_basket)),
              title: Text("Grocery Essentials Bundle", style: GoogleFonts.montserrat(fontSize: 14)),
              subtitle: Text("₹1,240 • 12 Items", style: GoogleFonts.montserrat(fontSize: 12)),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {}, 
                    icon: const Icon(Icons.support_agent, size: 18),
                    label: const Text("Support"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    child: Text(isActive ? "Track" : "Feedback", style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}