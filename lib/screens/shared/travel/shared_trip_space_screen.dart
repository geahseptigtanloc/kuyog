import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/kuyog_app_bar.dart';
import '../../../models/group_trip.dart';

class SharedTripSpaceScreen extends StatefulWidget {
  final GroupTrip trip;

  const SharedTripSpaceScreen({super.key, required this.trip});

  @override
  State<SharedTripSpaceScreen> createState() => _SharedTripSpaceScreenState();
}

class _SharedTripSpaceScreenState extends State<SharedTripSpaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KuyogAppBar(
        title: widget.trip.groupName,
        extraAction: IconButton(
          icon: const Icon(Icons.settings, color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              labelStyle: AppTheme.label(size: 14),
              tabs: const [
                Tab(icon: Icon(Icons.map_outlined), text: 'Itinerary'),
                Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Group Chat'),
                Tab(icon: Icon(Icons.group_outlined), text: 'Members'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItineraryTab(),
                _buildChatTab(),
                _buildMembersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 64, color: AppColors.primary.withAlpha(128)),
          const SizedBox(height: 16),
          Text('Shared Itinerary', style: AppTheme.headline(size: 20)),
          const SizedBox(height: 8),
          Text(
            'Collaborate with your group and guide here.\n(Connected to existing itinerary flow)',
            textAlign: TextAlign.center,
            style: AppTheme.body(size: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    // Simple mock group chat
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _systemMessage('Maria Santos created the group'),
              _systemMessage('Jose joined the trip'),
              _chatBubble('Hey everyone! Excited for our Davao trip!', 'Maria (Leader)', true, AppColors.accent),
              _chatBubble('Can\'t wait! Did we book a guide yet?', 'Jose', false, Colors.white),
              _systemMessage('Guide Rico Magbanua joined the trip'),
              _chatBubble('Maayong adlaw! I will be your guide. Check out the itinerary suggestions I just added.', 'Rico (Guide)', false, AppColors.primaryLight.withAlpha(51)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(backgroundColor: AppColors.primary, child: const Icon(Icons.send, color: Colors.white, size: 18)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _systemMessage(String text) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(AppRadius.pill)),
        child: Text(text, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _chatBubble(String text, String sender, bool isMe, Color bgColor) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(sender, style: AppTheme.label(size: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: !isMe && bgColor == Colors.white ? Border.all(color: AppColors.divider) : null,
              ),
              child: Text(text, style: AppTheme.body(size: 14, color: isMe ? Colors.white : AppColors.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Trip Members', style: AppTheme.headline(size: 18)),
        const SizedBox(height: 16),
        _memberRow('Maria Santos', 'maria@example.com', 'Trip Leader', 'active', isLeader: true),
        ...widget.trip.members.map((m) => _memberRow(m.name, m.email, m.role, m.status)),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.person_add),
          label: const Text('Invite More Members'),
        ),
      ],
    );
  }

  Widget _memberRow(String name, String email, String role, String status, {bool isLeader = false}) {
    Color statusColor = status == 'accepted' || status == 'active' ? AppColors.success : (status == 'pending' ? AppColors.warning : AppColors.error);
    String statusText = status == 'active' ? 'Active' : (status == 'accepted' ? 'Accepted' : (status == 'pending' ? 'Invite Sent' : 'Declined'));
    IconData statusIcon = status == 'accepted' || status == 'active' ? Icons.check_circle : (status == 'pending' ? Icons.access_time : Icons.cancel);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md), boxShadow: AppShadows.card),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryLight.withAlpha(51),
            child: Text(name[0], style: AppTheme.label(size: 16, color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: AppTheme.label(size: 15)),
                    if (isLeader) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.star, size: 14, color: AppColors.accent),
                    ],
                  ],
                ),
                Text(email, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.pill)),
            child: Row(
              children: [
                Icon(statusIcon, size: 12, color: statusColor),
                const SizedBox(width: 4),
                Text(statusText, style: AppTheme.label(size: 10, color: statusColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

