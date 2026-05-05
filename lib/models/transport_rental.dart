class TransportRental {
  final String id;
  final String partnerName;
  final String vehicleType; // van, car, airport_transfer, boat
  final String vehicleModel;
  final String plateNumber;
  final String photoUrl;
  final int capacity;
  final double pricePerDay;
  final double pricePerHalfDay;
  final double rating;
  final int reviewCount;
  final bool isKuyogVetted;
  final bool insuranceVerified;
  final bool hasValidLicense;
  final List<String> routes;
  final String description;

  const TransportRental({
    required this.id,
    required this.partnerName,
    required this.vehicleType,
    this.vehicleModel = '',
    this.plateNumber = '',
    this.photoUrl = '',
    this.capacity = 4,
    this.pricePerDay = 3000,
    this.pricePerHalfDay = 1800,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isKuyogVetted = true,
    this.insuranceVerified = true,
    this.hasValidLicense = true,
    this.routes = const [],
    this.description = '',
  });

  factory TransportRental.fromJson(Map<String, dynamic> json) {
    return TransportRental(
      id: json['id'] ?? '',
      partnerName: json['partnerName'] ?? '',
      vehicleType: json['vehicleType'] ?? 'van',
      vehicleModel: json['vehicleModel'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      capacity: json['capacity'] ?? 4,
      pricePerDay: (json['pricePerDay'] ?? 3000).toDouble(),
      pricePerHalfDay: (json['pricePerHalfDay'] ?? 1800).toDouble(),
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isKuyogVetted: json['isKuyogVetted'] ?? true,
      insuranceVerified: json['insuranceVerified'] ?? true,
      hasValidLicense: json['hasValidLicense'] ?? true,
      routes: List<String>.from(json['routes'] ?? []),
      description: json['description'] ?? '',
    );
  }
}
