import 'package:flutter/material.dart';
import '../models/tour_booking.dart';
import '../models/tour_operator.dart';
import '../data/services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final _bookingService = BookingService();
  TourPackage? _selectedPackage;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  int _groupSize = 2;
  final List<Map<String, dynamic>> _selectedAddOns = [];
  String _paymentMethod = 'GCash';
  List<TourBooking> _bookings = [];
  bool _isLoading = false;
  int _currentStep = 0;

  // Getters
  TourPackage? get selectedPackage => _selectedPackage;
  DateTime get selectedDate => _selectedDate;
  int get groupSize => _groupSize;
  List<Map<String, dynamic>> get selectedAddOns => _selectedAddOns;
  String get paymentMethod => _paymentMethod;
  List<TourBooking> get bookings => _bookings;
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;

  double get tourPrice => (_selectedPackage?.price ?? 0) * _groupSize;
  double get addOnsTotal => _selectedAddOns.fold(0.0, (sum, a) => sum + ((a['price'] as num?)?.toDouble() ?? 0));
  double get serviceFee => (tourPrice + addOnsTotal) * 0.08;
  double get totalPrice => tourPrice + addOnsTotal + serviceFee;

  List<TourBooking> get upcomingBookings {
    final now = DateTime.now();
    return _bookings.where((b) {
      // If it's today or later, it's upcoming
      final isFuture = b.date.year > now.year || 
                      (b.date.year == now.year && b.date.month > now.month) ||
                      (b.date.year == now.year && b.date.month == now.month && b.date.day >= now.day);
      return isFuture && b.status != 'cancelled' && b.status != 'completed';
    }).toList();
  }

  List<TourBooking> get pastBookings {
    final now = DateTime.now();
    return _bookings.where((b) {
      final isPast = b.date.year < now.year || 
                    (b.date.year == now.year && b.date.month < now.month) ||
                    (b.date.year == now.year && b.date.month == now.month && b.date.day < now.day);
      return isPast || b.status == 'completed';
    }).toList();
  }

  Future<void> loadBookings(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final rawBookings = await _bookingService.getTouristBookings(userId);
      _bookings = rawBookings.map((json) => TourBooking.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  void reset() {
    _selectedPackage = null;
    _selectedAddOns.clear();
    _groupSize = 2;
    _currentStep = 0;
    notifyListeners();
  }
}
