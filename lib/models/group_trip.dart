class GroupTrip {
  final String id;
  final String groupName;
  final String leaderId;
  final String travelType; // 'solo' or 'group'
  final String guideType; // 'community' or 'regional'
  final String guideId;
  final Map<String, String> dates;
  final String status; // 'planning', 'booked', etc.
  final List<GroupMember> members;
  final String itineraryId;

  const GroupTrip({
    required this.id,
    required this.groupName,
    required this.leaderId,
    required this.travelType,
    required this.guideType,
    required this.guideId,
    required this.dates,
    required this.status,
    required this.members,
    required this.itineraryId,
  });

  factory GroupTrip.fromJson(Map<String, dynamic> json) {
    return GroupTrip(
      id: json['id'] ?? '',
      groupName: json['group_name'] ?? json['groupName'] ?? '',
      leaderId: json['leader_id'] ?? json['leaderId'] ?? '',
      travelType: json['travel_type'] ?? json['travelType'] ?? 'group',
      guideType: json['guide_type'] ?? json['guideType'] ?? 'community',
      guideId: json['guide_id'] ?? json['guideId'] ?? '',
      dates: Map<String, String>.from(json['dates'] ?? {}),
      status: json['status'] ?? 'planning',
      members: (json['members'] as List<dynamic>?)
              ?.map((m) => GroupMember.fromJson(m))
              .toList() ??
          [],
      itineraryId: json['itinerary_id'] ?? json['itineraryId'] ?? '',
    );
  }
}

class GroupMember {
  final String name;
  final String email;
  final String role;
  final String status; // 'accepted', 'pending', 'declined'

  const GroupMember({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Friend',
      status: json['status'] ?? 'pending',
    );
  }
}
