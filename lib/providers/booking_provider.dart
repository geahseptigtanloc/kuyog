import 'package:flutter/material.dart';
import '../models/tour_booking.dart';
import '../models/tour_operator.dart';

class BookingProvider extends ChangeNotifier {
  TourPackage? _selectedPackage;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  int _groupSize = 2;
  final List<Map<String, dynamic>> _selectedAddOns = [];
  String _paymentMethod = 'GCash';
  final List<TourBooking> _bookings = [
    TourBooking(
      id: 'b_1',
      packageId: 'pkg_1',
      packageName: 'Samal Island Day Tour',
      operatorId: 'op_1',
      operatorName: 'Island Hop Express',
      userId: 'u_1',
      date: DateTime.now().add(const Duration(days: 2)),
      groupSize: 4,
      addOns: [],
      tourPrice: 4800,
      serviceFee: 384,
      totalPrice: 5184,
      status: 'active',
      paymentMethod: 'GCash',
      bookingRef: 'KYG-98231',
      photoUrl: 'https://picsum.photos/seed/samal/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      madayawPointsEarned: 150,
    ),
    TourBooking(
      id: 'b_2',
      packageId: 'pkg_2',
      packageName: 'Davao City Heritage Walk',
      operatorId: 'op_2',
      operatorName: 'Mindanao Tours',
      userId: 'u_1',
      date: DateTime.now().add(const Duration(days: 14)),
      groupSize: 2,
      addOns: [],
      tourPrice: 1500,
      serviceFee: 120,
      totalPrice: 1620,
      status: 'confirmed',
      paymentMethod: 'Credit Card',
      bookingRef: 'KYG-10293',
      photoUrl: 'https://picsum.photos/seed/davao/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      madayawPointsEarned: 80,
    ),
    TourBooking(
      id: 'b_3',
      packageId: 'pkg_3',
      packageName: 'Mt. Apo Expedition',
      operatorId: 'op_3',
      operatorName: 'Summit Peaks',
      userId: 'u_1',
      date: DateTime.now().subtract(const Duration(days: 30)),
      groupSize: 1,
      addOns: [],
      tourPrice: 12000,
      serviceFee: 960,
      totalPrice: 12960,
      status: 'completed',
      paymentMethod: 'GCash',
      bookingRef: 'KYG-00129',
      photoUrl: 'https://picsum.photos/seed/mtapo/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      madayawPointsEarned: 500,
    ),
  ];
  int _currentStep = 0;

  // Getters
  TourPackage? get selectedPackage => _selectedPackage;
  DateTime get selectedDate => _selectedDate;
  int get groupSize => _groupSize;
  List<Map<String, dynamic>> get selectedAddOns => _selectedAddOns;
  String get paymentMethod => _paymentMethod;
  List<TourBooking> get bookings => _bookings;
  int get currentStep => _currentStep;

  double get tourPrice => (_selectedPackage?.price ?? 0) * _groupSize;
  double get addOnsTotal => _selectedAddOns.fold(0.0, (sum, a) => sum + ((a['price'] as num?)?.toDouble() ?? 0));
  double get serviceFee => (tourPrice + addOnsTotal) * 0.08;
  double get totalPrice => tourPrice + addOnsTotal + serviceFee;

  List<TourBooking> get upcomingBookings => _bookings.where((b) => b.date.isAfter(DateTime.now()) && b.status != 'cancelled').toList();
  List<TourBooking> get pastBookings => _bookings.where((b) => b.date.isBefore(DateTime.now()) || b.status == 'completed').toList();

  void selectPackage(TourPackage pkg) {
    _selectedPackage = pkg;
    _selectedAddOns.clear();
    _currentStep = 0;
    notifyListeners();
  }

  void setDate(DateTime date) { _selectedDate = date; notifyListeners(); }
  void setGroupSize(int size) { _groupSize = size; notifyListeners(); }
  void setPaymentMethod(String m) { _paymentMethod = m; notifyListeners(); }
  void setStep(int step) { _currentStep = step; notifyListeners(); }

  void toggleAddOn(Map<String, dynamic> addOn) {
    final idx = _selectedAddOns.indexWhere((a) => a['name'] == addOn['name']);
    if (idx >= 0) { _selectedAddOns.removeAt(idx); } else { _selectedAddOns.add(addOn); }
    notifyListeners();
  }

  String confirmBooking({required String operatorId, required String operatorName, required String userId}) {
    final ref = 'KYG-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final booking = TourBooking(
      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
      packageId: _selectedPackage!.id,
      packageName: _selectedPackage!.name,
      operatorId: operatorId,
      operatorName: operatorName,
      userId: userId,
      date: _selectedDate,
      groupSize: _groupSize,
      addOns: List.from(_selectedAddOns),
      tourPrice: tourPrice,
      serviceFee: serviceFee,
      totalPrice: totalPrice,
      status: 'confirmed',
      paymentMethod: _paymentMethod,
      bookingRef: ref,
      photoUrl: _selectedPackage!.photoUrl,
      createdAt: DateTime.now(),
    );
    _bookings.add(booking);
    notifyListeners();
    return ref;
  }

  void completeTrip(String bookingId) {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx >= 0) {
      final old = _bookings[idx];
      _bookings[idx] = TourBooking(
        id: old.id, packageId: old.packageId, packageName: old.packageName,
        operatorId: old.operatorId, operatorName: old.operatorName, userId: old.userId,
        date: old.date, groupSize: old.groupSize, addOns: old.addOns,
        tourPrice: old.tourPrice, serviceFee: old.serviceFee, totalPrice: old.totalPrice,
        status: 'completed', paymentMethod: old.paymentMethod, bookingRef: old.bookingRef,
        photoUrl: old.photoUrl, createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  void reset() {
    _selectedPackage = null;
    _selectedAddOns.clear();
    _groupSize = 2;
    _currentStep = 0;
    notifyListeners();
  }
}
