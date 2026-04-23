import 'package:flutter/material.dart';

// Global address listener
final ValueNotifier<String> defaultAddressNotifier = 
    ValueNotifier<String>("Flat 402, Royal Residency, Sector 5...");

// NEW: Global Cart listener
final ValueNotifier<List<Map<String, String>>> cartNotifier = 
    ValueNotifier<List<Map<String, String>>>([]);


// 1. Add the listener
final ValueNotifier<String> languageNotifier = ValueNotifier<String>('en');

// 2. Add the words (you can add more later)
const Map<String, Map<String, String>> translations = {
  'en': {
    'my_account': 'My Account',
    'orders': 'Orders',
    'address': 'Address',
    'notifications': 'Notifications',
    'save_later': 'Save for later',
    'saved_payments': 'Saved Payments',
    'language': 'Choose App Language',
    'ratings': 'Rating & Reviews',
    'support': 'Support',
    'gift_cards': 'My Gift Cards',
    'confirm': 'Confirm',
    'lang_sub': 'Please select your preferred language.',
  },
  'hi': {
    'my_account': 'मेरा खाता',
    'orders': 'ऑर्डर',
    'address': 'पता',
    'notifications': 'सूचनाएं',
    'save_later': 'बाद के लिए सहेजें',
    'saved_payments': 'सुरक्षित भुगतान',
    'language': 'ऐप की भाषा चुनें',
    'ratings': 'रेटिंग और समीक्षाएं',
    'support': 'सहायता',
    'gift_cards': 'मेरे उपहार कार्ड',
    'confirm': 'पुष्टि करें',
    'lang_sub': 'कृपया अपनी पसंदीदा भाषा चुनें।',
  },
};

// Add this to your app_state.dart
final ValueNotifier<List<Map<String, String>>> savedCardsNotifier = ValueNotifier([
  {
    'bank': 'HDFC BANK DEBIT CARD',
    'number': '4421',
    'color': 'blue',
  },
  {
    'bank': 'SBI CREDIT CARD',
    'number': '8890',
    'color': 'orange',
  },
]);

// Add this to app_state.dart
final ValueNotifier<List<Map<String, String>>> savedUPINotifier = ValueNotifier([
  {'id': '9939963986@ybl', 'provider': 'PhonePe'},
  {'id': 'bibhanshu@oksbi', 'provider': 'Google Pay'},
]);


// Add this to app_state.dart
final ValueNotifier<List<Map<String, dynamic>>> userReviewsNotifier = ValueNotifier([
  {
    'productName': 'Premium Garam Masala',
    'rating': 5,
    'date': '20 April 2026',
    'comment': 'The aroma is authentic and fresh. Reminds me of home!',
    'image': 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=2070&auto=format&fit=crop',
  },
  {
    'productName': 'Organic Turmeric Powder',
    'rating': 4,
    'date': '15 March 2026',
    'comment': 'Very good quality, though the packaging could be better.',
    'image': 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?q=80&w=2070&auto=format&fit=crop',
  },
]);


// Add this to app_state.dart
final ValueNotifier<Map<String, String>> userProfileNotifier = ValueNotifier({
  'name': 'Bibhanshu Gupta',
  'email': 'bibhanshu@example.com',
  'phone': '+91 9939963986',
  'location': 'Jharkhand, India',
});


// Add this to app_state.dart
final ValueNotifier<List<Map<String, dynamic>>> orderHistoryNotifier = ValueNotifier([
  {
    'id': 'RM-9021',
    'date': '22 April 2026',
    'total': '₹850.00',
    'status': 'Delivered',
    'items': 'Premium Garam Masala, Organic Turmeric',
    'icon': Icons.check_circle_outline,
    'color': Colors.green,
  },
  {
    'id': 'RM-8842',
    'date': '18 April 2026',
    'total': '₹420.00',
    'status': 'Processing',
    'items': 'Black Pepper Powder (200g)',
    'icon': Icons.sync,
    'color': Colors.orange,
  },
  {
    'id': 'RM-7501',
    'date': '05 March 2026',
    'total': '₹1,200.00',
    'status': 'Cancelled',
    'items': 'Cumin Seeds, Red Chilli Powder',
    'icon': Icons.cancel_outlined,
    'color': Colors.red,
  },
]);

final ValueNotifier<List<Map<String, String>>> savedAddressesNotifier = ValueNotifier([
  {
    'title': 'Home',
    'address': 'Flat 402, Green Valley Apartments, Ranchi, Jharkhand',
    'phone': '+91 9939963986',
    'isDefault': 'true',
  },
  {
    'title': 'Office',
    'address': 'Freelance Studio, Sector 4, Bokaro Steel City',
    'phone': '+91 9939963986',
    'isDefault': 'false',
  },
]);

