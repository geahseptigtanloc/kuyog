import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String? imageUrl;
  final String? specialType; // 'itinerary', 'referral'
  final Map<String, dynamic>? specialData;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.imageUrl,
    this.specialType,
    this.specialData,
  });
}

class ChatThread {
  final String id;
  final String participantName;
  final String participantAvatar;
  final String participantRole;
  final List<ChatMessage> messages;
  final bool isOnline;

  ChatThread({
    required this.id,
    required this.participantName,
    required this.participantAvatar,
    required this.participantRole,
    required this.messages,
    this.isOnline = false,
  });

  String get lastMessage => messages.isNotEmpty ? messages.last.text : '';
  DateTime? get lastTimestamp => messages.isNotEmpty ? messages.last.timestamp : null;
  int get unreadCount => messages.where((m) => !m.isMe).length % 3; // mock unread
}

class ChatProvider extends ChangeNotifier {
  final List<ChatThread> _threads = [];

  List<ChatThread> get threads => _threads;

  int get totalUnreadCount => _threads.fold(0, (sum, t) => sum + t.unreadCount);

  ChatProvider() {
    _initMockThreads();
  }

  void _initMockThreads() {
    _threads.addAll([
      ChatThread(
        id: 'chat_1',
        participantName: 'Rico Magbanua',
        participantAvatar: 'https://picsum.photos/seed/rico/100/100',
        participantRole: 'Guide',
        isOnline: true,
        messages: [
          ChatMessage(id: '1', senderId: 'rico', text: 'Hi! I saw you were interested in the Mt. Apo trek.', timestamp: DateTime.now().subtract(const Duration(hours: 2)), isMe: false),
          ChatMessage(id: '2', senderId: 'me', text: 'Yes! I want to do the 3-day trek. Is it available next month?', timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)), isMe: true),
          ChatMessage(id: '3', senderId: 'rico', text: 'Absolutely! I have slots open for May 15-17. The weather should be perfect.', timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)), isMe: false),
        ],
      ),
      ChatThread(
        id: 'chat_2',
        participantName: 'Amina Lidasan',
        participantAvatar: 'https://picsum.photos/seed/amina/100/100',
        participantRole: 'Guide',
        isOnline: false,
        messages: [
          ChatMessage(id: '4', senderId: 'amina', text: 'Welcome to Cotabato! Let me know if you need any recommendations.', timestamp: DateTime.now().subtract(const Duration(days: 1)), isMe: false),
        ],
      ),
      ChatThread(
        id: 'chat_3',
        participantName: 'Fatima Store',
        participantAvatar: 'https://picsum.photos/seed/fatima/100/100',
        participantRole: 'Merchant',
        isOnline: true,
        messages: [
          ChatMessage(id: '5', senderId: 'me', text: 'Is the T\'nalak Bag still available?', timestamp: DateTime.now().subtract(const Duration(days: 2)), isMe: true),
          ChatMessage(id: '6', senderId: 'fatima', text: 'Yes! We have 5 left in stock. Would you like me to reserve one?', timestamp: DateTime.now().subtract(const Duration(days: 2, hours: -1)), isMe: false),
        ],
      ),
    ]);
  }

  ChatThread? getThread(String id) {
    try {
      return _threads.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void sendMessage(String threadId, String text) {
    final thread = getThread(threadId);
    if (thread == null) return;
    thread.messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    ));
    notifyListeners();

    // Auto-reply after 1.5s (mock)
    Future.delayed(const Duration(milliseconds: 1500), () {
      thread.messages.add(ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_reply',
        senderId: thread.id,
        text: _getAutoReply(),
        timestamp: DateTime.now(),
        isMe: false,
      ));
      notifyListeners();
    });
  }

  String _getAutoReply() {
    final replies = [
      'Sounds great! Let me check on that for you.',
      'Sure thing! I\'ll get back to you shortly.',
      'That\'s a wonderful choice! Let me prepare the details.',
      'Thank you for your interest! Here\'s what I recommend...',
      'Absolutely! Mindanao has so much to offer.',
    ];
    return replies[DateTime.now().second % replies.length];
  }

  void startChat(String name, String avatar, String role) {
    final existing = _threads.where((t) => t.participantName == name);
    if (existing.isNotEmpty) return;
    _threads.insert(0, ChatThread(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      participantName: name,
      participantAvatar: avatar,
      participantRole: role,
      isOnline: true,
      messages: [],
    ));
    notifyListeners();
  }
}
