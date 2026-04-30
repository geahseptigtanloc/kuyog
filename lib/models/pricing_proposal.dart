class PricingProposal {
  final String id;
  final String tourType; // 'Half Day Tour', 'Full Day Tour', 'Multi-Day Tour', 'Custom Package'
  final double baseRate;
  final String inclusions;
  final int minGuests;
  final int maxGuests;
  final double additionalPerPerson;
  final bool groupDiscount;
  final bool seniorPwdDiscount;
  final bool offPeakDiscount;
  final String notesToAdmin;
  final String status; // 'not_submitted', 'under_review', 'approved', 'revision_requested', 'rejected'
  final String? adminNote;

  const PricingProposal({
    required this.id,
    required this.tourType,
    this.baseRate = 0,
    this.inclusions = '',
    this.minGuests = 1,
    this.maxGuests = 10,
    this.additionalPerPerson = 0,
    this.groupDiscount = false,
    this.seniorPwdDiscount = false,
    this.offPeakDiscount = false,
    this.notesToAdmin = '',
    this.status = 'not_submitted',
    this.adminNote,
  });

  factory PricingProposal.fromJson(Map<String, dynamic> json) {
    return PricingProposal(
      id: json['id'] ?? '',
      tourType: json['tourType'] ?? '',
      baseRate: (json['baseRate'] ?? 0).toDouble(),
      inclusions: json['inclusions'] ?? '',
      minGuests: json['minGuests'] ?? 1,
      maxGuests: json['maxGuests'] ?? 10,
      additionalPerPerson: (json['additionalPerPerson'] ?? 0).toDouble(),
      groupDiscount: json['groupDiscount'] ?? false,
      seniorPwdDiscount: json['seniorPwdDiscount'] ?? false,
      offPeakDiscount: json['offPeakDiscount'] ?? false,
      notesToAdmin: json['notesToAdmin'] ?? '',
      status: json['status'] ?? 'not_submitted',
      adminNote: json['adminNote'],
    );
  }
}
