import 'package:flutter/material.dart';
import '../models/group_trip.dart';
import '../models/guide.dart';
import '../models/tour_operator.dart';
import '../data/mock_data.dart';

class TravelProvider extends ChangeNotifier {
  String _travelType = 'solo'; // 'solo' or 'group'
  String _guideType = 'community'; // 'community' or 'regional'
  
  // Group Setup State
  String _groupName = '';
  List<GroupMember> _members = [];
  String _selectedGuideId = '';
  
  // Tourist Preferences (Mocked for now, in a real app would come from UserProvider)
  final List<String> _userPrefs = ['Adventure Travel', 'Mountain Trekking', 'Photography'];

  // AI Matching Data
  List<Guide> _allGuides = [];
  List<TourOperator> _allOperators = [];
  bool _isLoadingMatches = true;

  // Getters
  String get travelType => _travelType;
  String get guideType => _guideType;
  String get groupName => _groupName;
  List<GroupMember> get members => _members;
  String get selectedGuideId => _selectedGuideId;
  bool get isLoadingMatches => _isLoadingMatches;
  List<String> get userPrefs => _userPrefs;

  TravelProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _allGuides = await MockData.getGuides();
    _allOperators = await MockData.getTourOperators();
    _isLoadingMatches = false;
    notifyListeners();
  }

  // Setters
  void setTravelAndGuideType(String travel, String guide) {
    _travelType = travel;
    _guideType = guide;
    notifyListeners();
  }

  void setGroupName(String name) {
    _groupName = name;
    notifyListeners();
  }

  void addMember(GroupMember member) {
    if (_members.length < 9) {
      _members.add(member);
      notifyListeners();
    }
  }

  void removeMember(int index) {
    if (index >= 0 && index < _members.length) {
      _members.removeAt(index);
      notifyListeners();
    }
  }

  void selectGuide(String guideId) {
    _selectedGuideId = guideId;
    notifyListeners();
  }

  // AI Matching Logic
  int calculateMatchScore(List<String> userTags, List<String> guideTags) {
    if (userTags.isEmpty || guideTags.isEmpty) return 0;
    
    int matches = 0;
    for (String tag in userTags) {
      if (guideTags.contains(tag)) {
        matches++;
      }
    }
    
    // Calculate percentage, maxing out at 98 for realism
    double percentage = (matches / userTags.length) * 100;
    if (percentage > 0 && percentage < 40) {
       // Bump up base score a bit for partial matches
       percentage += 30;
    }
    int score = percentage.round();
    return score > 98 ? 98 : score;
  }

  List<Guide> getMatchedGuides() {
    List<Guide> filteredGuides = _allGuides.where((g) {
      if (g.guideType != _guideType) return false;
      if (_travelType == 'group') {
        int totalPax = _members.length + 1; // +1 for leader
        if (!g.groupToursExperience || g.maxGroupSize < totalPax) return false;
      }
      return true;
    }).toList();

    // Map guides to a new list with calculated scores
    List<Guide> scoredGuides = filteredGuides.map((g) {
      int calculatedScore = g.matchScore > 0 ? g.matchScore : calculateMatchScore(_userPrefs, g.matchTags);
      
      return Guide(
        id: g.id,
        name: g.name,
        city: g.city,
        specialties: g.specialties,
        rating: g.rating,
        tripCount: g.tripCount,
        reviewCount: g.reviewCount,
        bio: g.bio,
        certifications: g.certifications,
        photoUrl: g.photoUrl,
        bannerUrl: g.bannerUrl,
        isVerified: g.isVerified,
        itineraryPhotos: g.itineraryPhotos,
        yearsExperience: g.yearsExperience,
        languages: g.languages,
        priceRange: g.priceRange,
        specialty: g.specialty,
        guideType: g.guideType,
        matchScore: calculatedScore,
        dotAccredited: g.dotAccredited,
        lguEndorsed: g.lguEndorsed,
        trainingDays: g.trainingDays,
        storyExcerpt: g.storyExcerpt,
        fullStory: g.fullStory,
        acceptedPayments: g.acceptedPayments,
        pricingStatus: g.pricingStatus,
        communityArea: g.communityArea,
        maxGroupSize: g.maxGroupSize,
        groupToursExperience: g.groupToursExperience,
        matchTags: g.matchTags,
      );
    }).toList();

    scoredGuides.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return scoredGuides;
  }

  List<TourOperator> getMatchedOperators() {
    List<TourOperator> filteredOps = _allOperators.where((op) {
      if (_travelType == 'group') {
        int totalPax = _members.length + 1;
        if (op.maxGroupSize < totalPax) return false;
      }
      return true;
    }).toList();

    List<TourOperator> scoredOps = filteredOps.map((op) {
      int calculatedScore = op.matchScore > 0 ? op.matchScore : calculateMatchScore(_userPrefs, op.matchTags);
      return TourOperator(
        id: op.id,
        companyName: op.companyName,
        logoUrl: op.logoUrl,
        location: op.location,
        dotAccredited: op.dotAccredited,
        businessPermitVerified: op.businessPermitVerified,
        specialties: op.specialties,
        guideCount: op.guideCount,
        rating: op.rating,
        reviewCount: op.reviewCount,
        packages: op.packages,
        description: op.description,
        bannerUrl: op.bannerUrl,
        matchTags: op.matchTags,
        maxGroupSize: op.maxGroupSize,
        totalTours: op.totalTours,
        matchScore: calculatedScore,
      );
    }).toList();

    scoredOps.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return scoredOps;
  }
}
