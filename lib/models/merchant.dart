class Merchant {
  final String id;
  final String businessName;
  final String businessType;
  final String description;
  final String address;
  final String logoUrl;
  final String bannerUrl;
  final double rating;
  final int productsCount;
  final int ordersToday;
  final double salesToday;
  final bool isVerified;
  final String operatingHours;
  // V3 additions
  final bool businessPermit;
  final bool dotAccredited;
  final String dataSource;

  const Merchant({
    required this.id,
    required this.businessName,
    required this.businessType,
    this.description = '',
    this.address = '',
    required this.logoUrl,
    this.bannerUrl = '',
    this.rating = 4.7,
    this.productsCount = 24,
    this.ordersToday = 8,
    this.salesToday = 3200,
    this.isVerified = true,
    this.operatingHours = '8:00 AM - 8:00 PM',
    this.businessPermit = true,
    this.dotAccredited = false,
    this.dataSource = '',
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'] ?? '',
      businessName: json['businessName'] ?? '',
      businessType: json['businessType'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      rating: (json['rating'] ?? 4.7).toDouble(),
      productsCount: json['productsCount'] ?? 0,
      ordersToday: json['ordersToday'] ?? 0,
      salesToday: (json['salesToday'] ?? 0).toDouble(),
      isVerified: json['isVerified'] ?? true,
      operatingHours: json['operatingHours'] ?? '8:00 AM - 8:00 PM',
      businessPermit: json['businessPermit'] ?? true,
      dotAccredited: json['dotAccredited'] ?? false,
      dataSource: json['dataSource'] ?? '',
    );
  }
}
