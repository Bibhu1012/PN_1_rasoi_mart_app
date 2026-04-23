import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/AppStateManagment/app_state.dart';
import 'add_review_screen.dart'; // Make sure to import the new screen

class RatingsReviewsScreen extends StatelessWidget {
  const RatingsReviewsScreen({super.key});

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
              words['ratings_reviews'] ?? "My Reviews",
              style: GoogleFonts.montserrat(
                color: Colors.black, 
                fontWeight: FontWeight.bold, 
                fontSize: 18
              ),
            ),
          ),
          
          // Floating Action Button to add a new review
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddReviewScreen()),
              );
            },
            backgroundColor: Colors.brown,
            icon: const Icon(Icons.edit, color: Colors.white, size: 20),
            label: const Text(
              "Write Review", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
          ),

          body: ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: userReviewsNotifier,
            builder: (context, reviews, child) {
              if (reviews.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Extra bottom padding for FAB
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  // Displaying latest reviews first
                  final review = reviews.reversed.toList()[index];
                  // Calculate actual index for deletion
                  final actualIndex = reviews.length - 1 - index;
                  
                  return _buildReviewCard(context, review, actualIndex);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  review['image'] ?? 'https://via.placeholder.com/150',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['productName'],
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.brown.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          Icons.star,
                          size: 16,
                          color: starIndex < review['rating']
                              ? Colors.orange
                              : Colors.grey.shade300,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                onPressed: () => _confirmDeleteReview(context, index),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.black12, height: 1),
          ),
          Text(
            review['comment'],
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              review['date'],
              style: const TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.rate_review_outlined, size: 60, color: Colors.brown),
          ),
          const SizedBox(height: 20),
          Text(
            "No reviews yet",
            style: GoogleFonts.montserrat(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Share your experience with our products!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteReview(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Delete Review?"),
        content: const Text("Are you sure you want to remove this feedback?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel", style: TextStyle(color: Colors.grey))
          ),
          TextButton(
            onPressed: () {
              var currentList = List<Map<String, dynamic>>.from(userReviewsNotifier.value);
              currentList.removeAt(index);
              userReviewsNotifier.value = currentList;
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}