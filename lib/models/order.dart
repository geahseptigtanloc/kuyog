class Order {
  final String id;
  final String customerName;
  final String customerAvatar;
  final List<OrderItem> items;
  final double total;
  final String status; // New, Processing, Ready, Completed, Cancelled
  final String deliveryAddress;
  final String paymentMethod;
  final DateTime orderDate;
  final String estimatedDelivery;

  const Order({
    required this.id,
    required this.customerName,
    this.customerAvatar = '',
    required this.items,
    required this.total,
    this.status = 'New',
    this.deliveryAddress = '',
    this.paymentMethod = 'GCash',
    required this.orderDate,
    this.estimatedDelivery = '3-5 days',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      customerAvatar: json['customerAvatar'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((i) => OrderItem.fromJson(i))
              .toList() ??
          [],
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'New',
      deliveryAddress: json['deliveryAddress'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'GCash',
      orderDate: DateTime.tryParse(json['orderDate'] ?? '') ?? DateTime.now(),
      estimatedDelivery: json['estimatedDelivery'] ?? '3-5 days',
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.productName,
    this.imageUrl = '',
    required this.price,
    this.quantity = 1,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}
