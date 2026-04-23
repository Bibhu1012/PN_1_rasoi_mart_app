import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  // Initial location set to Chandigarh region
  LatLng _currentPosition = const LatLng(30.7333, 76.7794);
  String _mapAddress = "Locating...";
  final TextEditingController _detailController = TextEditingController();
  GoogleMapController? _mapController;
  bool _isLoading = false;

  // Function to convert Coordinates to a readable address
  Future<void> _getAddressFromLatLng() async {
    setState(() => _isLoading = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          // Constructing a clean address string
          _mapAddress = "${place.name}, ${place.subLocality}, ${place.locality} ${place.postalCode}";
        });
      }
    } catch (e) {
      debugPrint("Error fetching address: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. THE MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 15),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) => _currentPosition = position.target,
            onCameraIdle: () => _getAddressFromLatLng(),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),

          // 2. FIXED CENTER PIN
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: Icon(Icons.location_on, color: Colors.red, size: 45),
            ),
          ),

          // 3. BOTTOM DETAIL PANEL
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_city, color: Colors.brown, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Confirm Location",
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Auto-fetched address from Map
                  Text(
                    _isLoading ? "Updating address..." : _mapAddress,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  
                  const Divider(height: 30),

                  // User Detail Input (Flat, Floor, Landmark)
                  Text(
                    "Detailed Address",
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _detailController,
                    decoration: InputDecoration(
                      hintText: "Flat/House No., Floor, Landmark",
                      hintStyle: const TextStyle(fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // Combine the map address with user details
                        String fullAddress = "${_detailController.text.trim()}, $_mapAddress";
                        Navigator.pop(context, fullAddress);
                      },
                      child: Text(
                        "Save This Location",
                        style: GoogleFonts.montserrat(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}