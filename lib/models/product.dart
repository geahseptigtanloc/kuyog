class Product {
  final String id;
  final String name;
  final String merchantName;
  final String merchantId;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> images;
  final String category;
  final double rating;
  final int soldCount;
  final int stock;
  final bool isActive;
  final bool isMindanaoMade;
  final List<String> variants;
  final bool isFlashDeal;
  final double? originalPrice;

  const Product({
    required this.id,
    required this.name,
    required this.merchantName,
    this.merchantId = '',
    this.description = '',
    required this.price,
    required this.imageUrl,
    this.images = const [],
    this.category = 'Crafts',
    this.rating = 4.5,
    this.soldCount = 0,
    this.stock = 50,
    this.isActive = true,
    this.isMindanaoMade = true,
    this.variants = const [],
    this.isFlashDeal = false,
    this.originalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      merchantName: json['merchantName'] ?? '',
      merchantId: json['merchantId'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? 'Crafts',
      rating: (json['rating'] ?? 4.5).toDouble(),
      soldCount: json['soldCount'] ?? 0,
      stock: json['stock'] ?? 50,
      isActive: json['isActive'] ?? true,
      isMindanaoMade: json['isMindanaoMade'] ?? true,
      variants: List<String>.from(json['variants'] ?? []),
      isFlashDeal: json['isFlashDeal'] ?? false,
      originalPrice: json['originalPrice']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'merchantName': merchantName,
      'merchantId': merchantId,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'rating': rating,
      'soldCount': soldCount,
      'stock': stock,
      'isActive': isActive,
      'isMindanaoMade': isMindanaoMade,
      'variants': variants,
      'isFlashDeal': isFlashDeal,
      'originalPrice': originalPrice,
    };
  }
}
