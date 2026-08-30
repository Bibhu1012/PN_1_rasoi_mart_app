import 'package:flutter/material.dart';

class SubCategoryItem {
  final String name;
  final IconData icon;
  const SubCategoryItem({required this.name, required this.icon});
}

class ProductItem {
  final String brand;
  final String name;
  final String qty;
  final int price;
  final int oldPrice;
  final String deliveryTime;
  final bool isVeg;
  const ProductItem({
    required this.brand,
    required this.name,
    required this.qty,
    required this.price,
    required this.oldPrice,
    this.deliveryTime = "11 mins",
    this.isVeg = true,
  });

  int get discountPercent =>
      oldPrice > price ? (((oldPrice - price) / oldPrice) * 100).round() : 0;
}

class MainCategoryItem {
  final String name;
  final IconData icon;
  final Color accentColor;
  final List<SubCategoryItem> subCategories;
  final List<ProductItem> bestsellers;

  const MainCategoryItem({
    required this.name,
    required this.icon,
    required this.accentColor,
    required this.subCategories,
    required this.bestsellers,
  });
}

class CategorySection {
  final String title;
  final List<MainCategoryItem> items;
  const CategorySection({required this.title, required this.items});
}

class CategoryData {
  static const List<CategorySection> sections = [
    CategorySection(
      title: "Fresh",
      items: [
        MainCategoryItem(
          name: "Fruits & Veggies",
          icon: Icons.eco,
          accentColor: Color(0xFF3F7D45),
          subCategories: [
            SubCategoryItem(name: "Fresh Vegetables", icon: Icons.grass),
            SubCategoryItem(name: "Fresh Fruits", icon: Icons.apple),
            SubCategoryItem(name: "Herbs & Seasoning", icon: Icons.local_florist),
            SubCategoryItem(name: "Exotic F&V", icon: Icons.local_pizza),
            SubCategoryItem(name: "Sprouts", icon: Icons.spa),
            SubCategoryItem(name: "Cuts & Peeled", icon: Icons.content_cut),
            SubCategoryItem(name: "Organic F&V", icon: Icons.recycling),
            SubCategoryItem(name: "Flowers & Leaves", icon: Icons.local_florist_outlined),
          ],
          bestsellers: [
            ProductItem(brand: "Fresho", name: "Tomato Local", qty: "1 kg", price: 28, oldPrice: 35),
            ProductItem(brand: "Fresho", name: "Onion", qty: "1 kg", price: 32, oldPrice: 40),
            ProductItem(brand: "Fresho", name: "Potato", qty: "1 kg", price: 24, oldPrice: 30),
            ProductItem(brand: "Fresho", name: "Banana Robusta", qty: "6 pcs", price: 42, oldPrice: 48),
            ProductItem(brand: "Fresho", name: "Apple Shimla", qty: "4 pcs", price: 120, oldPrice: 150),
          ],
        ),
        MainCategoryItem(
          name: "Bakery & Batters",
          icon: Icons.bakery_dining,
          accentColor: Color(0xFFB1652E),
          subCategories: [
            SubCategoryItem(name: "Bread", icon: Icons.breakfast_dining),
            SubCategoryItem(name: "Buns & Pavs", icon: Icons.lunch_dining),
            SubCategoryItem(name: "Cakes & Muffins", icon: Icons.cake),
            SubCategoryItem(name: "Idli/Dosa Batter", icon: Icons.blender),
            SubCategoryItem(name: "Khakra", icon: Icons.grain),
            SubCategoryItem(name: "Rusk & Wafers", icon: Icons.cookie),
            SubCategoryItem(name: "Pizza Base", icon: Icons.local_pizza),
            SubCategoryItem(name: "Gourmet Breads", icon: Icons.bakery_dining_outlined),
          ],
          bestsellers: [
            ProductItem(brand: "The Health Factory", name: "Zero Maida Bread", qty: "400 g", price: 65, oldPrice: 75),
            ProductItem(brand: "Britannia", name: "White Bread", qty: "400 g", price: 45, oldPrice: 50),
            ProductItem(brand: "ID", name: "Idli Dosa Batter", qty: "1 kg", price: 68, oldPrice: 75),
            ProductItem(brand: "Modern", name: "Burger Buns", qty: "4 pcs", price: 40, oldPrice: 45),
          ],
        ),
        MainCategoryItem(
          name: "Dairy",
          icon: Icons.icecream,
          accentColor: Color(0xFF2E6DA4),
          subCategories: [
            SubCategoryItem(name: "Milk", icon: Icons.local_drink),
            SubCategoryItem(name: "Curd & Yogurt", icon: Icons.icecream_outlined),
            SubCategoryItem(name: "Paneer & Tofu", icon: Icons.crop_square),
            SubCategoryItem(name: "Butter", icon: Icons.bakery_dining),
            SubCategoryItem(name: "Cheese", icon: Icons.circle),
            SubCategoryItem(name: "Cream", icon: Icons.blender),
            SubCategoryItem(name: "Ghee", icon: Icons.opacity),
            SubCategoryItem(name: "Buttermilk & Lassi", icon: Icons.emoji_food_beverage),
          ],
          bestsellers: [
            ProductItem(brand: "Amul", name: "Toned Milk", qty: "1 L", price: 32, oldPrice: 34),
            ProductItem(brand: "Nestle", name: "Fresh Curd", qty: "400 g", price: 45, oldPrice: 50),
            ProductItem(brand: "Amul", name: "Paneer", qty: "200 g", price: 95, oldPrice: 105),
            ProductItem(brand: "Amul", name: "Butter", qty: "100 g", price: 55, oldPrice: 58),
          ],
        ),
        MainCategoryItem(
          name: "Eggs, Meat & Fish",
          icon: Icons.set_meal,
          accentColor: Color(0xFF8C3A3A),
          subCategories: [
            SubCategoryItem(name: "Eggs", icon: Icons.egg),
            SubCategoryItem(name: "Chicken", icon: Icons.set_meal),
            SubCategoryItem(name: "Mutton", icon: Icons.kebab_dining),
            SubCategoryItem(name: "Fish & Seafood", icon: Icons.phishing),
            SubCategoryItem(name: "Marinades", icon: Icons.soup_kitchen),
            SubCategoryItem(name: "Sausages & Salami", icon: Icons.lunch_dining),
            SubCategoryItem(name: "Frozen Meat", icon: Icons.ac_unit),
            SubCategoryItem(name: "Prawns", icon: Icons.set_meal_outlined),
          ],
          bestsellers: [
            ProductItem(brand: "Licious", name: "Farm Eggs", qty: "6 pcs", price: 48, oldPrice: 54, isVeg: false),
            ProductItem(brand: "Licious", name: "Chicken Curry Cut", qty: "500 g", price: 149, oldPrice: 170, isVeg: false),
            ProductItem(brand: "FreshToHome", name: "Rohu Fish", qty: "500 g", price: 189, oldPrice: 210, isVeg: false),
          ],
        ),
      ],
    ),
    CategorySection(
      title: "Grocery & Kitchen",
      items: [
        MainCategoryItem(
          name: "Atta, Rice, Dal & More",
          icon: Icons.grain,
          accentColor: Color(0xFF3F5D3A),
          subCategories: [
            SubCategoryItem(name: "Atta & Flours", icon: Icons.bakery_dining),
            SubCategoryItem(name: "Dals & Pulses", icon: Icons.grain),
            SubCategoryItem(name: "Salt, Sugar & Jaggery", icon: Icons.icecream_outlined),
            SubCategoryItem(name: "Organic Picks", icon: Icons.eco),
            SubCategoryItem(name: "Rice", icon: Icons.rice_bowl),
            SubCategoryItem(name: "Sooji, Besan & Maida", icon: Icons.blender),
            SubCategoryItem(name: "Poha, Sabudana & More", icon: Icons.grain_outlined),
            SubCategoryItem(name: "Millets & More", icon: Icons.spa),
          ],
          bestsellers: [
            ProductItem(brand: "BB Royal", name: "Superior Chakki Wheat Atta", qty: "5 kg", price: 179, oldPrice: 290),
            ProductItem(brand: "Tata Salt", name: "Vacuum Evaporated Iodised Salt", qty: "1 kg", price: 29, oldPrice: 32),
            ProductItem(brand: "BB Popular", name: "Toor/Arhar Dal", qty: "1 kg", price: 119, oldPrice: 275),
            ProductItem(brand: "Daawat", name: "Basmati Rice", qty: "1 kg", price: 145, oldPrice: 165),
          ],
        ),
        MainCategoryItem(
          name: "Oil, Ghee & Masala",
          icon: Icons.opacity,
          accentColor: Color(0xFF8A5A22),
          subCategories: [
            SubCategoryItem(name: "Cooking Oils", icon: Icons.opacity),
            SubCategoryItem(name: "Ghee", icon: Icons.local_fire_department),
            SubCategoryItem(name: "Whole Spices", icon: Icons.grain),
            SubCategoryItem(name: "Masala Powders", icon: Icons.blender),
            SubCategoryItem(name: "Seasoning", icon: Icons.restaurant),
            SubCategoryItem(name: "Dry Chillies", icon: Icons.local_fire_department_outlined),
          ],
          bestsellers: [
            ProductItem(brand: "Fortune", name: "Sunflower Oil", qty: "1 L", price: 158, oldPrice: 180),
            ProductItem(brand: "Kashmirlal", name: "Kashmiri Red Chilli Powder", qty: "200 g", price: 89, oldPrice: 105),
            ProductItem(brand: "Everest", name: "Garam Masala", qty: "100 g", price: 89, oldPrice: 110),
          ],
        ),
        MainCategoryItem(
          name: "Dry Fruits & Cereals",
          icon: Icons.grain,
          accentColor: Color(0xFF9A6A1F),
          subCategories: [
            SubCategoryItem(name: "Almonds", icon: Icons.grain),
            SubCategoryItem(name: "Cashews", icon: Icons.grain),
            SubCategoryItem(name: "Raisins", icon: Icons.grain),
            SubCategoryItem(name: "Muesli & Oats", icon: Icons.breakfast_dining),
            SubCategoryItem(name: "Seeds", icon: Icons.spa),
            SubCategoryItem(name: "Mixed Dry Fruits", icon: Icons.emoji_food_beverage),
          ],
          bestsellers: [
            ProductItem(brand: "Kelloggs", name: "Muesli Fruit Nut & Seeds", qty: "500 g", price: 265, oldPrice: 320),
            ProductItem(brand: "Happilo", name: "California Almonds", qty: "200 g", price: 199, oldPrice: 240),
          ],
        ),
        MainCategoryItem(
          name: "Kitchen Must-Haves",
          icon: Icons.kitchen,
          accentColor: Color(0xFF555555),
          subCategories: [
            SubCategoryItem(name: "Appliances", icon: Icons.blender),
            SubCategoryItem(name: "Storage & Containers", icon: Icons.inventory_2),
            SubCategoryItem(name: "Cookware", icon: Icons.soup_kitchen),
            SubCategoryItem(name: "Bottles & Tumblers", icon: Icons.local_drink),
          ],
          bestsellers: [
            ProductItem(brand: "Signoraware", name: "Mixer Grinder", qty: "1 pc", price: 1899, oldPrice: 2299),
            ProductItem(brand: "Cello", name: "Water Bottle", qty: "1 L", price: 199, oldPrice: 249),
          ],
        ),
      ],
    ),
    CategorySection(
      title: "Snacks & Drinks",
      items: [
        MainCategoryItem(
          name: "Hot & Cold Beverages",
          icon: Icons.emoji_food_beverage,
          accentColor: Color(0xFF6B3E26),
          subCategories: [
            SubCategoryItem(name: "Tea", icon: Icons.emoji_food_beverage),
            SubCategoryItem(name: "Coffee", icon: Icons.coffee),
            SubCategoryItem(name: "Soft Drinks", icon: Icons.local_drink),
            SubCategoryItem(name: "Juices", icon: Icons.local_bar),
            SubCategoryItem(name: "Health Drinks", icon: Icons.fitness_center),
            SubCategoryItem(name: "Water", icon: Icons.water_drop),
          ],
          bestsellers: [
            ProductItem(brand: "Tata Gold", name: "Premium Tea", qty: "1 kg", price: 480, oldPrice: 540),
            ProductItem(brand: "Coca-Cola", name: "Soft Drink Can", qty: "300 ml", price: 40, oldPrice: 45),
          ],
        ),
        MainCategoryItem(
          name: "Namkeen & Chips",
          icon: Icons.fastfood,
          accentColor: Color(0xFFB03A2E),
          subCategories: [
            SubCategoryItem(name: "Potato Chips", icon: Icons.fastfood),
            SubCategoryItem(name: "Bhujia & Sev", icon: Icons.grain),
            SubCategoryItem(name: "Namkeen Mixtures", icon: Icons.rice_bowl),
            SubCategoryItem(name: "Popcorn", icon: Icons.local_movies),
          ],
          bestsellers: [
            ProductItem(brand: "Haldiram's", name: "Bhujia Sev", qty: "200 g", price: 55, oldPrice: 65),
            ProductItem(brand: "Lays", name: "Classic Salted Chips", qty: "52 g", price: 20, oldPrice: 20),
          ],
        ),
        MainCategoryItem(
          name: "Biscuits & Cookies",
          icon: Icons.cookie,
          accentColor: Color(0xFF7A4A24),
          subCategories: [
            SubCategoryItem(name: "Cream Biscuits", icon: Icons.cookie),
            SubCategoryItem(name: "Glucose & Marie", icon: Icons.cookie_outlined),
            SubCategoryItem(name: "Cookies", icon: Icons.bakery_dining),
            SubCategoryItem(name: "Crackers", icon: Icons.grain),
          ],
          bestsellers: [
            ProductItem(brand: "Good Day", name: "Mega Family Pack", qty: "1 kg", price: 145, oldPrice: 170),
            ProductItem(brand: "Dark Fantasy", name: "Choco Fills", qty: "300 g", price: 99, oldPrice: 115),
          ],
        ),
        MainCategoryItem(
          name: "Instant & Frozen Food",
          icon: Icons.icecream,
          accentColor: Color(0xFF2E5D8A),
          subCategories: [
            SubCategoryItem(name: "Noodles & Pasta", icon: Icons.ramen_dining),
            SubCategoryItem(name: "Frozen Snacks", icon: Icons.ac_unit),
            SubCategoryItem(name: "Ready to Eat/Cook", icon: Icons.soup_kitchen),
            SubCategoryItem(name: "French Fries", icon: Icons.fastfood),
          ],
          bestsellers: [
            ProductItem(brand: "McCain", name: "French Fries", qty: "425 g", price: 129, oldPrice: 150),
            ProductItem(brand: "Maggi", name: "2-Minute Noodles", qty: "12 pack", price: 140, oldPrice: 160),
          ],
        ),
      ],
    ),
    CategorySection(
      title: "Beauty & Personal Care",
      items: [
        MainCategoryItem(
          name: "Skin Care",
          icon: Icons.face_retouching_natural,
          accentColor: Color(0xFFB8628A),
          subCategories: [
            SubCategoryItem(name: "Face Wash", icon: Icons.face),
            SubCategoryItem(name: "Moisturizers", icon: Icons.water_drop),
            SubCategoryItem(name: "Sunscreen", icon: Icons.wb_sunny),
            SubCategoryItem(name: "Face Masks", icon: Icons.face_retouching_natural),
          ],
          bestsellers: [
            ProductItem(brand: "Nivea", name: "Soft Light Moisturizer", qty: "100 ml", price: 199, oldPrice: 230),
            ProductItem(brand: "Neutrogena", name: "Sunscreen SPF 50", qty: "50 ml", price: 399, oldPrice: 450),
          ],
        ),
        MainCategoryItem(
          name: "Hair Care",
          icon: Icons.content_cut,
          accentColor: Color(0xFF4A4A4A),
          subCategories: [
            SubCategoryItem(name: "Shampoo", icon: Icons.local_drink),
            SubCategoryItem(name: "Conditioner", icon: Icons.spa),
            SubCategoryItem(name: "Hair Oil", icon: Icons.opacity),
            SubCategoryItem(name: "Hair Color", icon: Icons.palette),
          ],
          bestsellers: [
            ProductItem(brand: "Dove", name: "Nourishing Shampoo", qty: "340 ml", price: 245, oldPrice: 280),
            ProductItem(brand: "Parachute", name: "Coconut Hair Oil", qty: "250 ml", price: 110, oldPrice: 125),
          ],
        ),
        MainCategoryItem(
          name: "Bath & Body",
          icon: Icons.bathtub,
          accentColor: Color(0xFF2E7D6B),
          subCategories: [
            SubCategoryItem(name: "Soaps & Handwash", icon: Icons.soap),
            SubCategoryItem(name: "Body Wash", icon: Icons.bathtub),
            SubCategoryItem(name: "Body Lotion", icon: Icons.water_drop),
            SubCategoryItem(name: "Deodorants", icon: Icons.emoji_events),
          ],
          bestsellers: [
            ProductItem(brand: "Dettol", name: "Handwash Refill", qty: "750 ml", price: 129, oldPrice: 145),
            ProductItem(brand: "Nivea", name: "Body Lotion", qty: "400 ml", price: 289, oldPrice: 320),
          ],
        ),
      ],
    ),
  ];
}