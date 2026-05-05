import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kuyog/models/crawl_route.dart';
import '../models/guide.dart';
import '../models/destination.dart';
import '../models/post.dart';
import '../models/product.dart';
import '../models/merchant.dart';
import '../models/event.dart';
import '../models/notification_item.dart';
import '../models/order.dart';
import '../models/review.dart';
import '../models/itinerary.dart';
import '../models/match_request.dart';
import '../models/tour_operator.dart';
import '../models/group_trip.dart';
import '../models/transport_rental.dart';
import '../models/madayaw_season.dart';

class MockData {
  static List<Guide>? _guides;
  static List<Destination>? _destinations;
  static List<Post>? _posts;
  static List<Product>? _products;
  static List<Merchant>? _merchants;
  static List<CrawlEvent>? _events;
  static List<NotificationItem>? _notifications;
  static List<Order>? _orders;
  static List<Review>? _reviews;
  static List<Itinerary>? _itineraries;
  static List<MatchRequest>? _matchRequests;
  static List<TourOperator>? _tourOperators;
  static List<GroupTrip>? _groupTrips;
  static List<CrawlRoute>? _crawlRoutes;
  static List<Map<String, dynamic>>? _crawlMerch;
  static List<TourPackage>? _tourPackages;
  static List<TransportRental>? _transportPartners;
  static List<MadayawSeason>? _madayawSeasons;

  static Future<List<T>> _load<T>(String path, T Function(Map<String, dynamic>) fromJson) async {
    final data = await rootBundle.loadString(path);
    final list = json.decode(data) as List;
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<Guide>> getGuides() async {
    _guides ??= await _load('assets/data/mock_guides.json', Guide.fromJson);
    return _guides!;
  }

  static Future<List<Destination>> getDestinations() async {
    _destinations ??= await _load('assets/data/mock_destinations.json', Destination.fromJson);
    return _destinations!;
  }

  static Future<List<Post>> getPosts() async {
    _posts ??= await _load('assets/data/mock_posts.json', Post.fromJson);
    return _posts!;
  }

  static Future<List<Product>> getProducts() async {
    _products ??= await _load('assets/data/mock_products.json', Product.fromJson);
    return _products!;
  }

  static Future<List<Merchant>> getMerchants() async {
    _merchants ??= await _load('assets/data/mock_merchants.json', Merchant.fromJson);
    return _merchants!;
  }

  static Future<List<CrawlEvent>> getEvents() async {
    _events ??= await _load('assets/data/mock_events.json', CrawlEvent.fromJson);
    return _events!;
  }

  static Future<List<NotificationItem>> getNotifications() async {
    _notifications ??= await _load('assets/data/mock_notifications.json', NotificationItem.fromJson);
    return _notifications!;
  }

  static Future<List<Order>> getOrders() async {
    _orders ??= await _load('assets/data/mock_orders.json', Order.fromJson);
    return _orders!;
  }

  static Future<List<Review>> getReviews() async {
    _reviews ??= await _load('assets/data/mock_reviews.json', Review.fromJson);
    return _reviews!;
  }

  static Future<List<Itinerary>> getItineraries() async {
    _itineraries ??= await _load('assets/data/mock_itineraries.json', Itinerary.fromJson);
    return _itineraries!;
  }

  static Future<List<MatchRequest>> getMatchRequests() async {
    _matchRequests ??= await _load('assets/data/mock_match_requests.json', MatchRequest.fromJson);
    return _matchRequests!;
  }

  static Future<List<TourOperator>> getTourOperators() async {
    _tourOperators ??= await _load('assets/data/mock_tour_operators.json', TourOperator.fromJson);
    return _tourOperators!;
  }

  static Future<List<GroupTrip>> getGroupTrips() async {
    _groupTrips ??= await _load('assets/data/mock_group_trips.json', GroupTrip.fromJson);
    return _groupTrips!;
  }

  static Future<List<CrawlRoute>> getCrawlRoutes() async {
    _crawlRoutes ??= await _load('assets/data/mock_crawl_routes.json', CrawlRoute.fromJson);
    return _crawlRoutes!;
  }

  static Future<List<Map<String, dynamic>>> getCrawlMerch() async {
    if (_crawlMerch == null) {
      final data = await rootBundle.loadString('assets/data/crawl_merch.json');
      final list = json.decode(data) as List;
      _crawlMerch = list.map((e) => e as Map<String, dynamic>).toList();
    }
    return _crawlMerch!;
  }

  static Future<List<TourPackage>> getTourPackages() async {
    _tourPackages ??= await _load('assets/data/mock_tour_packages.json', TourPackage.fromJson);
    return _tourPackages!;
  }

  static Future<List<TransportRental>> getTransportPartners() async {
    _transportPartners ??= await _load('assets/data/mock_transport_partners.json', TransportRental.fromJson);
    return _transportPartners!;
  }

  static Future<List<MadayawSeason>> getMadayawSeasons() async {
    _madayawSeasons ??= await _load('assets/data/mock_madayaw_seasons.json', MadayawSeason.fromJson);
    return _madayawSeasons!;
  }
}
