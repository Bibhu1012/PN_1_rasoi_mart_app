import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rasoimart/screens/Bottom_Tabs/Category/All_Categoties/category_models.dart';
import 'category_models.dart';
import 'category_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const Color tileBackground = Color(0xFFF2F2F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF1E4CE),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            ...CategoryData.sections.map(
              (section) => SliverToBoxAdapter(child: _buildSection(context, section)),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Categories",
            style: GoogleFonts.montserrat(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.search, size: 26, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, CategorySection section) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: GoogleFonts.montserrat(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: section.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) => _buildCategoryTile(context, section.items[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, MainCategoryItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryDetailScreen(category: item)),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: tileBackground, borderRadius: BorderRadius.circular(14)),
              child: Icon(item.icon, color: item.accentColor, size: 30),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.2),
          ),
        ],
      ),
    );
  }
}