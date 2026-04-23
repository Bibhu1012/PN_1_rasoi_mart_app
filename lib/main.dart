import 'package:flutter/material.dart';
import 'package:rasoimart/screens/Main_Screen/main_screen.dart';
import 'package:rasoimart/screens/login/login_screen.dart';


void main() {
  runApp(const RasoiMart());
}

class RasoiMart extends StatelessWidget {
  const RasoiMart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rasoi Mart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Setting the seed color to Orange to match your Rasoi Mart branding
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFECA369)), 
        useMaterial3: true,
      ),
      // For now, I'm setting this to MainScreen so you can see your 
      // Bottom Nav and Category screen immediately. 
      // Switch back to LoginScreen() when your authentication logic is ready.
      home: const LoginScreen(), 
    );
  }
}