import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_theme.dart';
import '../../providers/match_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/match_request.dart';

class MatchRequestsScreen extends StatefulWidget {
  const MatchRequestsScreen({super.key});
  @override
  State<MatchRequestsScreen> createState() => _MatchRequestsScreenState();
}

class _MatchRequestsScreenState extends State<MatchRequestsScreen> with SingleTickerProviderStateMixin {
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text('Match Requests', style: AppTheme.headline(size: 24)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppShadows.card),
                    child: const Icon(Icons.filter_list, size: 20, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: AppShadows.card,
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerHeight: 0,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  labelStyle: AppTheme.label(size: 13),
                  unselectedLabelStyle: AppTheme.body(size: 13),
                  tabs: const [Tab(text: 'Pending'), Tab(text: 'Accepted'), Tab(text: 'Declined')],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<MatchProvider>(
                builder: (context, matchProvider, _) {
                  if (matchProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(matchProvider.pendingRequests, 'pending'),
                      _buildList(matchProvider.acceptedRequests, 'accepted'),
                      _buildList(matchProvider.declinedRequests, 'declined'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<MatchRequest> requests, String type) {
    if (requests.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            type == 'pending' ? Icons.hourglass_empty : type == 'accepted' ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 64, color: AppColors.primary.withAlpha(76),
          ),
          const SizedBox(height: 16),
          Text(
            type == 'pending' ? 'No pending requests' : type == 'accepted' ? 'No accepted matches yet' : 'No declined requests',
            style: AppTheme.body(size: 16, color: AppColors.textSecondary),
          ),
        ]),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: requests.length,
      itemBuilder: (context, i) => _requestCard(requests[i]),
    );
  }

  Widget _requestCard(MatchRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
        border: request.status == 'pending' ? Border.all(color: AppColors.primary.withAlpha(51)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 28, backgroundImage: CachedNetworkImageProvider(request.touristAvatar)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(request.touristName, style: AppTheme.label(size: 15)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.touristBlue.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.pill)),
                      child: Text('Tourist', style: AppTheme.label(size: 9, color: AppColors.touristBlue)),
                    ),
                  ]),
                  Text(request.touristLocation, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text('${request.matchScore}% Match', style: AppTheme.label(size: 11, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6, runSpacing: 4,
            children: request.travelPreferences.map((pref) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.primary.withAlpha(51)),
              ),
              child: Text(pref, style: AppTheme.body(size: 11, color: AppColors.primary)),
            )).toList(),
          ),
          if (request.destinationsOfInterest.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.place, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  request.destinationsOfInterest.join(', '),
                  style: AppTheme.body(size: 12, color: AppColors.textSecondary),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ],
          if (request.travelDates.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(request.travelDates, style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
            ]),
          ],
          if (request.status == 'pending') ...[
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showDeclineDialog(request),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _acceptMatch(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Accept'),
                ),
              ),
            ]),
          ],
          if (request.status == 'accepted') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('Match Accepted', style: AppTheme.label(size: 12, color: AppColors.primary)),
              ]),
            ),
          ],
          if (request.status == 'declined') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.error.withAlpha(26), borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.cancel, size: 14, color: AppColors.error),
                const SizedBox(width: 4),
                Text('Declined${request.declineReason != null ? ': ${request.declineReason}' : ''}', style: AppTheme.label(size: 12, color: AppColors.error)),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  void _acceptMatch(MatchRequest request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('Accept match with ${request.touristName}?', style: AppTheme.headline(size: 18)),
        content: Text('A chat will be opened automatically.', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: AppTheme.label(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              context.read<MatchProvider>().acceptRequest(request.id);
              context.read<ChatProvider>().startChat(request.touristName, request.touristAvatar, 'Tourist');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Match accepted! Chat opened with ${request.touristName}', style: AppTheme.body(size: 14, color: Colors.white)),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _showDeclineDialog(MatchRequest request) {
    String? reason;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('Decline match?', style: AppTheme.headline(size: 18)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Optionally select a reason:', style: AppTheme.body(size: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ...['Not available on those dates', 'Outside my expertise', 'Fully booked', 'Other'].map((r) =>
            InkWell(
              onTap: () { reason = r; Navigator.pop(ctx); context.read<MatchProvider>().declineRequest(request.id, reason); },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppRadius.sm)),
                child: Text(r, style: AppTheme.body(size: 14)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

