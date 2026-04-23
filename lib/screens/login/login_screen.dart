import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rasoimart/screens/login/otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Logic Variables (The missing parts)
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonActive = false;

  // Define custom colors based on your design
  static const Color appBackgroundColor = Color(0xFFF1E4CE);
  static const Color appMainButtonColor = Color(0xFFDC2626);
  static const Color appGoogleButtonColor = Color(0xFF4285F4);
  static const Color appFooterColor = Color(0xFFDCCFBB);

  @override
  void initState() {
    super.initState();
    // 2. Add listener to validate input in real-time
    _phoneController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      // Button activates only when length is exactly 10
      _isButtonActive = _phoneController.text.length == 10;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              
              // 1. App Name
              Text(
                'Rasoi Mart',
                textAlign: TextAlign.center,
                style: GoogleFonts.alegreya(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
              
              // 2. Tagline
              Text(
                'Taste the Best At Your Home',
                textAlign: TextAlign.center,
                style: GoogleFonts.dancingScript(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 3. Central Logo
              Center(
                child: Image.asset(
                  'assets/images/rasoi_mart_logo.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_basket, size: 100, color: Colors.orange),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // 4. Header & Sub-header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    Text(
                      'Your last minute App',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Login or Sign up',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 35),
              
              // 5. Phone Input Field (Wrapped in Container + Row for layout)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("🇮🇳", style: TextStyle(fontSize: 20)),
                      ),
                      Container(width: 1, height: 35, color: Colors.grey.shade300),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Enter mobile number',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                            prefixText: "+91 ",
                            prefixStyle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 6. Send OTP Button (State-Aware)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isButtonActive 
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpVerificationScreen(
                                  phoneNumber: "+91 ${_phoneController.text}",
                                ),
                              ),
                            );
                          } 
                        : null, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonActive ? appMainButtonColor : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Send OTP',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 7. OR Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.black38, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'OR',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.black38, thickness: 1)),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 8. Social Sign-In Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    SocialButton(
                      text: "Sign in with Google",
                      color: appGoogleButtonColor,
                      textColor: Colors.white,
                      iconWidget: Container(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          'assets/images/google_logo.png',
                          height: 20,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SocialButton(
                      text: "Sign in with Apple",
                      color: Colors.black,
                      textColor: Colors.white,
                      iconWidget: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Image.asset(
                          'assets/images/apple_logo.png',
                          height: 20,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60), 
              
              // 9. Footer
              Container(
                width: double.infinity,
                color: appFooterColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          'By continuing, you agree to our: ',
                          style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey.shade800),
                        ),
                        Text(
                          'Terms of Service',
                          style: GoogleFonts.montserrat(
                            fontSize: 12, 
                            color: Colors.grey.shade900, 
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text('& ', style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey.shade800)),
                        Text(
                          'Privacy policy',
                          style: GoogleFonts.montserrat(
                            fontSize: 12, 
                            color: Colors.grey.shade900, 
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Widget iconWidget;

  const SocialButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: iconWidget,
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}