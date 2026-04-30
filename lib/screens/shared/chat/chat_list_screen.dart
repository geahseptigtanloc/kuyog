import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/chat_provider.dart';
import '../../../widgets/kuyog_back_button.dart';
import '../../../widgets/durie_loading.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.card),
                    child: const Icon(Icons.edit_note, size: 22, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.pill), boxShadow: AppShadows.card),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textLight, size: 20),
                    const SizedBox(width: 10),
                    Text('Search conversations...', style: AppTheme.body(size: 14, color: AppColors.textLight)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  if (chatProvider.threads.isEmpty) {
                    return const DurieEmptyState(
                      message: 'No messages yet',
                      subtitle: 'Start a conversation!',
                    );
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: chatProvider.threads.length,
                    itemBuilder: (context, i) => _chatTile(context, chatProvider.threads[i]),
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
          color: unread > 0 ? AppColors.primary.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
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
                          style: AppTheme.label(size: 14).copyWith(fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w600),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _roleColor(thread.participantRole).withOpacity(0.1),
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
                          ).copyWith(fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400),
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
