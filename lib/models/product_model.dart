import 'package:rasoimart/screens/Bottom_Tabs/Category/All_Categoties/category_models.dart';

class Product {
  final String name;
  final String qty;
  final String price;
  final String oldPrice;
  final String description;
  final String image;
  final List<String> nutritionInfo;

  Product({
    required this.name,
    required this.qty,
    required this.price,
    required this.oldPrice,
    required this.description,
    required this.image,
    required this.nutritionInfo,
  });

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
    );
  }
}
