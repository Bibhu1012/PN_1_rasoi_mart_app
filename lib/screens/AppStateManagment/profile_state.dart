import 'dart:io';

class ProfileState {
  static String name = "";
  static String email = "";
  static String phone = ""; // Added to store mobile number
  static File? profileImage;
  static bool isEmailVerified = false;

  // Track the last time the name was updated
  static DateTime? lastNameChangeDate; 

  /// Returns true if the user can change their name (30-day rule)
  static bool canChangeName() {
    if (lastNameChangeDate == null) return true;
    
    final difference = DateTime.now().difference(lastNameChangeDate!).inDays;
    return difference >= 30;
  }

  /// Returns the number of days left until the name can be changed again
  static int daysUntilNextNameChange() {
    if (lastNameChangeDate == null) return 0;
    
    final difference = DateTime.now().difference(lastNameChangeDate!).inDays;
    return (30 - difference).clamp(0, 30);
  }
}