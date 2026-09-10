import 'package:rasoimart/screens/Bottom_Tabs/Category/All_Categoties/category_models.dart';

/// Represents one purchasable pack size of a product (e.g. "1 kg", "5 kg"),
/// each with its own price/MRP — used to render the "Select Unit" cards.
class ProductUnit {
  final String label; // e.g. "1 kg"
  final double price;
  final double oldPrice;
  final int? stockLeft;

  const ProductUnit({
    required this.label,
    required this.price,
    required this.oldPrice,
    this.stockLeft,
  });

  int get discountPercent =>
      oldPrice > price ? (((oldPrice - price) / oldPrice) * 100).round() : 0;

  /// Rough per-kg price shown under each unit card (e.g. "₹57.2/kg").
  /// Parses a leading number + kg/g from the label; falls back to price itself.
  double get pricePerKg {
    final match = RegExp(r'([\d.]+)\s*(kg|g)', caseSensitive: false).firstMatch(label);
    if (match == null) return price;
    double value = double.tryParse(match.group(1) ?? '1') ?? 1;
    final unit = match.group(2)!.toLowerCase();
    if (unit == 'g') value = value / 1000;
    if (value == 0) return price;
    return price / value;
  }
}

class Product {
  final String name;
  final String qty;
  final String price;
  final String oldPrice;
  final String description;
  final String image;
  final List<String> nutritionInfo;

  // ---- Newer optional fields (all default to safe values so existing
  // Product.fromMap(...) / Product.fromItem(...) calls keep working as-is) ----
  final String brand;
  final double rating;
  final String ratingCount;
  final String deliveryTime;
  final String? calorieContent;
  final String? proteinContent;
  final String tagline;
  final List<ProductUnit> units;
  final int stockLeft;

  Product({
    required this.name,
    required this.qty,
    required this.price,
    required this.oldPrice,
    required this.description,
    required this.image,
    required this.nutritionInfo,
    this.brand = "Rasoi Mart",
    this.rating = 4.3,
    this.ratingCount = "1,200",
    this.deliveryTime = "11 mins",
    this.calorieContent,
    this.proteinContent,
    this.tagline = "",
    this.units = const [],
    this.stockLeft = 10,
  });

  /// True when this product should show the multi-pack "Select Unit" cards
  /// instead of a single price line.
  bool get hasMultipleUnits => units.isNotEmpty;

  int get discountPercent {
    final p = double.tryParse(price) ?? 0;
    final o = double.tryParse(oldPrice) ?? 0;
    return o > p ? (((o - p) / o) * 100).round() : 0;
  }

  // Helper to convert from the Map format used in HomeScreen
  factory Product.fromMap(Map<String, String> map, {String? description, List<String>? nutrition}) {
    return Product(
      name: map['name'] ?? 'Unknown Product',
      qty: map['qty'] ?? '',
      price: map['price'] ?? '0',
      oldPrice: map['old'] ?? '0',
      description: description ?? 'No description available for this product.',
      image: map['image'] ?? 'assets/images/all.png',
      nutritionInfo: nutrition ?? ['No information available'],
    );
  }

  // Helper to convert from ProductItem used in Category screens
  factory Product.fromItem(ProductItem item, {String? description, List<String>? nutrition}) {
    return Product(
      name: item.name,
      qty: item.qty,
      price: item.price.toString(),
      oldPrice: item.oldPrice.toString(),
      description: description ?? 'This is a premium quality ${item.name} from ${item.brand}. Freshly sourced and delivered to your home.',
      image: 'assets/images/all.png', // Generic image as ProductItem doesn't have one
      nutritionInfo: nutrition ?? ['High Quality', 'Freshly Sourced', 'Safe & Hygienic'],
      brand: item.brand,
      deliveryTime: item.deliveryTime,
    );
  }

  /// Example factory showing how to build a product WITH the new multi-unit /
  /// rating / calorie fields, matching the "Right Shift Atta" screenshot.
  /// Use this pattern wherever you want the richer detail page.
  factory Product.demoRich() {
    return Product(
      name: "Right Shift Multigrain Atta (High Protein, Low GI)",
      qty: "5 kg",
      price: "286",
      oldPrice: "449",
      description:
          "A wholesome multigrain atta blended with chana and millets for 30% more protein and a low glycemic index — helps keep you fuller for longer while supporting digestion and muscle health.",
      image: "assets/images/all.png",
      nutritionInfo: const [
        "30% More Protein",
        "Low GI (Glycemic Index)",
        "Aids Digestion",
        "Supports Muscle Health",
      ],
      brand: "Right Shift",
      rating: 4.5,
      ratingCount: "1,857",
      deliveryTime: "12 mins",
      calorieContent: "335 kcal / 100g",
      proteinContent: "14g / 100g",
      tagline: "STRONGER SOFTER SMARTER",
      stockLeft: 4,
      units: const [
        ProductUnit(label: "1 kg", price: 72, oldPrice: 95),
        ProductUnit(label: "5 kg", price: 286, oldPrice: 449),
      ],
    );
  }
}