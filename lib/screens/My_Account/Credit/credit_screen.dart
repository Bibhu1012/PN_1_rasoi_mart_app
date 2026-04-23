import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditScreen extends StatelessWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black), title: Text("Credit Dashboard", style: GoogleFonts.montserrat(color: Colors.black))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Text("Available to Spend", style: GoogleFonts.montserrat(color: Colors.white70)),
                  Text("₹12,450", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _stat("Total Limit", "₹15,000"),
                      _stat("Used Credit", "₹2,550"),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            _infoTile("Due Date", "05 May, 2026", Colors.red),
            _infoTile("Payment Status", "Pending", Colors.orange),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {},
                child: Text("CLEAR DUES", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String val) => Column(children: [Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)), Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]);

  Widget _infoTile(String label, String val, Color col) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: GoogleFonts.montserrat(fontSize: 16)), Text(val, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: col))]),
  );
}