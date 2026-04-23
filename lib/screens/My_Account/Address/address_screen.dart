import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'package:rasoimart/screens/My_Account/Address/Map_picker/MapPickerScreen.dart';
import 'package:rasoimart/screens/My_Account/Address/manage_address/manage_address_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // Initial addresses - in a real app, these would come from a database/API
  final List<Map<String, String>> addresses = [
    {'title': 'Home', 'address': 'Flat 402, Royal Residency, Sector 5, Chandigarh'},
    {'title': 'Office', 'address': 'Phase 8B, Industrial Area, Mohali, Punjab'},
  ];

  void _navigateToManageAddress({Map<String, String>? addressToEdit, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageAddressScreen(
          addressData: addressToEdit,
          isEditing: addressToEdit != null,
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        if (index != null) {
          addresses[index] = result;
        } else {
          addresses.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E4CE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text("Saved Addresses", style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return ValueListenableBuilder<Map<String, String>>(
                  valueListenable: userProfileNotifier,
                  builder: (context, profile, _) {
                    bool isDefault = profile['location'] == addresses[index]['address'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDefault ? Colors.brown : Colors.transparent, width: 2),
                      ),
                      child: ListTile(
                        onTap: () {
                          userProfileNotifier.value = {
                            ...userProfileNotifier.value,
                            'location': addresses[index]['address']!,
                          };
                        },
                        leading: Icon(
                          addresses[index]['title'] == 'Home' ? Icons.home : Icons.work,
                          color: isDefault ? Colors.brown : Colors.grey,
                        ),
                        title: Text(addresses[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(addresses[index]['address']!, style: const TextStyle(fontSize: 12)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blueGrey),
                              onPressed: () => _navigateToManageAddress(addressToEdit: addresses[index], index: index),
                            ),
                            if (isDefault) const Icon(Icons.check_circle, color: Colors.brown),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: // Update your action buttons in AddressScreen.dart
Row(
  children: [
    Expanded(
      child: _actionBtn("Add via Map", Icons.map, () async {
        // Direct jump to Map then to Form
        final String? mapAddress = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapPickerScreen()),
        );
        if (mapAddress != null) {
          _navigateToManageAddress(addressToEdit: {'title': '', 'address': mapAddress});
        }
      }),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _actionBtn("Manual Add", Icons.add_location_alt, () => _navigateToManageAddress()),
    ),
  ],
)
          )
        ],
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, VoidCallback onTap) => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      );
}