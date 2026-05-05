class TourBooking {
  final String id;
  final String packageId;
  final String packageName;
  final String operatorId;
  final String operatorName;
  final String userId;
  final DateTime date;
  final int groupSize;
  final List<Map<String, dynamic>> addOns;
  final double tourPrice;
  final double serviceFee;
  final double totalPrice;
  final String status; // pending, confirmed, active, completed, cancelled
  final String paymentMethod;
  final String bookingRef;
  final String pickupLocation;
  final String operatorPhone;
  final String photoUrl;
  final DateTime createdAt;
  final int madayawPointsEarned;

  const TourBooking({
    required this.id,
    required this.packageId,
    required this.packageName,
    required this.operatorId,
    required this.operatorName,
    required this.userId,
    required this.date,
    required this.groupSize,
    this.addOns = const [],
    required this.tourPrice,
    required this.serviceFee,
    required this.totalPrice,
    this.status = 'pending',
    this.paymentMethod = 'GCash',
    this.bookingRef = '',
    this.pickupLocation = '',
    this.operatorPhone = '',
    this.photoUrl = '',
    required this.createdAt,
    this.madayawPointsEarned = 500,
  });

  factory TourBooking.fromJson(Map<String, dynamic> json) {
    return TourBooking(
      id: json['id'] ?? '',
      packageId: json['packageId'] ?? '',
      packageName: json['packageName'] ?? '',
      operatorId: json['operatorId'] ?? '',
      operatorName: json['operatorName'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      groupSize: json['groupSize'] ?? 1,
      addOns: (json['addOns'] as List<dynamic>?)
              ?.map((a) => Map<String, dynamic>.from(a))
              .toList() ?? [],
      tourPrice: (json['tourPrice'] ?? 0).toDouble(),
      serviceFee: (json['serviceFee'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? 'GCash',
      bookingRef: json['bookingRef'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      operatorPhone: json['operatorPhone'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      madayawPointsEarned: json['madayawPointsEarned'] ?? 500,
    );
  }
}
