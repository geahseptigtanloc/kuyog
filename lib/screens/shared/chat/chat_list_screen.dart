import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/chat_provider.dart';
import '../../../widgets/durie_loading.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _showSearch = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  KuyogBackButton(onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  Text('Messages', style: AppTheme.headline(size: 24)),
                  const Spacer(),
                  InkWell(
                    onTap: () => setState(() => _showSearch = !_showSearch),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.card),
                      child: Icon(_showSearch ? Icons.close : Icons.search, size: 20, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            if (_showSearch) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  style: AppTheme.body(size: 14),
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textLight),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.pill), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  final threads = chatProvider.threads.where((t) {
                    if (_searchQuery.isEmpty) return true;
                    return t.participantName.toLowerCase().contains(_searchQuery);
                  }).toList();

                  if (threads.isEmpty) {
                    return const DurieEmptyState(
                      message: 'No conversations yet',
                      subtitle: 'Start by matching with a guide!',
                    );
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: threads.length,
                    itemBuilder: (context, i) => _chatTile(context, threads[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatTile(BuildContext context, ChatThread thread) {
    final unread = thread.unreadCount;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(threadId: thread.id))),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unread > 0 ? AppColors.primary.withAlpha(10) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
          border: unread > 0 ? Border(left: BorderSide(color: AppColors.primary, width: 3)) : null,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: CachedNetworkImageProvider(thread.participantAvatar),
                ),
                if (thread.isOnline)
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.participantName,
                          style: AppTheme.label(size: 15).copyWith(fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w600),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _roleColor(thread.participantRole).withAlpha(26),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(thread.participantRole, style: AppTheme.label(size: 9, color: _roleColor(thread.participantRole))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.lastMessage,
                          style: AppTheme.body(
                            size: 13,
                            color: unread > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                          ).copyWith(
                            fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400,
                            fontStyle: unread > 0 ? FontStyle.normal : FontStyle.italic,
                          ),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (thread.lastTimestamp != null)
                        Text(_formatTime(thread.lastTimestamp!), style: AppTheme.body(size: 11, color: AppColors.textLight)),
                    ],
                  ),
                ],
              ),
            ),
            if (unread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'Guide': return AppColors.guideGreen;
      case 'Merchant': return AppColors.merchantAmber;
      default: return AppColors.touristBlue;
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

