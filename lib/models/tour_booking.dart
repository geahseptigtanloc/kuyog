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
  final String operatorPhotoUrl;
  final List<Map<String, dynamic>> fullItinerary;
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
    this.operatorPhotoUrl = '',
    this.fullItinerary = const [],
    required this.createdAt,
    this.madayawPointsEarned = 500,
  });

  factory TourBooking.fromJson(Map<String, dynamic> json) {
    // Handle joined package data from Supabase if available
    final package = json['jsu_packages'] as Map<String, dynamic>?;
    final operator = json['operator'] as Map<String, dynamic>?;
    
    return TourBooking(
      id: json['id'] ?? '',
      packageId: json['packageid'] ?? json['packageId'] ?? '',
      packageName: package?['name'] ?? json['packageName'] ?? '',
      operatorId: json['operatorid'] ?? json['operatorId'] ?? '',
      operatorName: operator?['name'] ?? json['operatorName'] ?? 'Operator',
      operatorPhotoUrl: operator?['avatarUrl'] ?? '',
      userId: json['touristid'] ?? json['userId'] ?? '',
      date: json['tourdate'] != null ? DateTime.parse(json['tourdate']) : 
            (json['date'] != null ? DateTime.parse(json['date']) : DateTime.now()),
      groupSize: json['paxcount'] ?? json['groupSize'] ?? 1,
      addOns: (json['selectedaddons'] ?? json['addOns'] as List<dynamic>?)
              ?.map((a) => Map<String, dynamic>.from(a))
              .toList()
              .cast<Map<String, dynamic>>() ?? [],
      tourPrice: (json['totalamount'] ?? json['tourPrice'] ?? 0).toDouble() - (json['servicefee'] ?? json['serviceFee'] ?? 0).toDouble(),
      serviceFee: (json['servicefee'] ?? json['serviceFee'] ?? 0).toDouble(),
      totalPrice: (json['totalamount'] ?? json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentmethod'] ?? json['paymentMethod'] ?? 'GCash',
      bookingRef: json['referencecode'] ?? json['bookingRef'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      operatorPhone: json['operatorPhone'] ?? '',
      photoUrl: package?['photourl'] ?? json['photoUrl'] ?? '',
      fullItinerary: (package?['itinerary'] as List<dynamic>?)
              ?.map((i) => Map<String, dynamic>.from(i))
              .toList()
              .cast<Map<String, dynamic>>() ?? [],
      createdAt: json['createdat'] != null ? DateTime.parse(json['createdat']) : 
                (json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now()),
      madayawPointsEarned: json['madayawPointsEarned'] ?? 500,
    );
  }
}
