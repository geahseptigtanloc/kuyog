import 'package:flutter/material.dart';
import '../models/transport_rental.dart';

class TransportProvider extends ChangeNotifier {
  List<TransportRental> _partners = [];
  TransportRental? _selectedPartner;
  DateTime _rentalDate = DateTime.now().add(const Duration(days: 3));
  bool _isFullDay = true;
  bool _waiverAccepted = false;
  String _paymentMethod = 'GCash';
  String _pickupLocation = '';
  String _dropoffLocation = '';

  List<TransportRental> get partners => _partners;
  TransportRental? get selectedPartner => _selectedPartner;
  DateTime get rentalDate => _rentalDate;
  bool get isFullDay => _isFullDay;
  bool get waiverAccepted => _waiverAccepted;
  String get paymentMethod => _paymentMethod;
  String get pickupLocation => _pickupLocation;
  String get dropoffLocation => _dropoffLocation;

  double get rentalPrice => _selectedPartner == null ? 0 : (_isFullDay ? _selectedPartner!.pricePerDay : _selectedPartner!.pricePerHalfDay);
  double get serviceFee => rentalPrice * 0.08;
  double get totalPrice => rentalPrice + serviceFee;

  void setPartners(List<TransportRental> p) { _partners = p; notifyListeners(); }
  void selectPartner(TransportRental p) { _selectedPartner = p; notifyListeners(); }
  void setRentalDate(DateTime d) { _rentalDate = d; notifyListeners(); }
  void setFullDay(bool v) { _isFullDay = v; notifyListeners(); }
  void setWaiverAccepted(bool v) { _waiverAccepted = v; notifyListeners(); }
  void setPaymentMethod(String m) { _paymentMethod = m; notifyListeners(); }
  void setPickupLocation(String l) { _pickupLocation = l; notifyListeners(); }
  void setDropoffLocation(String l) { _dropoffLocation = l; notifyListeners(); }

  List<TransportRental> getByType(String type) => _partners.where((p) => p.vehicleType == type).toList();

  void reset() {
    _selectedPartner = null;
    _waiverAccepted = false;
    _isFullDay = true;
    notifyListeners();
  }
}
