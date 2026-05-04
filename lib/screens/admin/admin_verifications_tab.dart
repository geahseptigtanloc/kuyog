import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../data/services/admin_service.dart';
import 'package:intl/intl.dart';
import 'admin_verification_detail_screen.dart';

class AdminVerificationsTab extends StatefulWidget {
  const AdminVerificationsTab({super.key});

  @override
  State<AdminVerificationsTab> createState() => _AdminVerificationsTabState();
}

class _AdminVerificationsTabState extends State<AdminVerificationsTab> {
  final _adminService = AdminService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _guides = [];
  List<Map<String, dynamic>> _merchants = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final guides = await _adminService.getPendingGuideVerifications();
      final merchants = await _adminService.getPendingMerchantVerifications();
      setState(() {
        _guides = guides;
        _merchants = merchants;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading verifications: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String type, String id, String status) async {
    try {
      if (type == 'guide') {
        await _adminService.updateGuideVerificationStatus(id, status);
      } else {
        await _adminService.updateMerchantVerificationStatus(id, status);
      }
      _loadData(); // Reload after update
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Application $status!'),
          backgroundColor: status == 'approved' ? AppColors.success : AppColors.error,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  int _countDocs(Map<String, dynamic> item) {
    int count = 0;
    for (var value in item.values) {
      if (value is String && value.startsWith('http')) {
        count++;
      }
    }
    return count;
  }

  String _formatDate(String? isoString) {
    if (isoString == null) return 'Unknown';
    final date = DateTime.parse(isoString).toLocal();
    return DateFormat('MMM d, yyyy').format(date);
  }

  void _openDetails(Map<String, dynamic> data, String type) {
    final id = type == 'guide' ? data['guide_id'] : data['merchant_id'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminVerificationDetailScreen(
          data: data,
          type: type,
          onApprove: () => _updateStatus(type, id, 'approved'),
          onReject: () => _updateStatus(type, id, 'rejected'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _guides.where((g) => g['status'] == 'submitted').length + 
                         _merchants.where((m) => m['status'] == 'submitted').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), child: Row(children: [
            Text('Verifications', style: AppTheme.headline(size: 24)),
            const Spacer(),
            if (!_isLoading)
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
                child: Text('$pendingCount pending', style: AppTheme.label(size: 12, color: AppColors.warning))),
          ])),
          
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : (_guides.isEmpty && _merchants.isEmpty)
                ? Center(child: Text('No verifications found', style: AppTheme.body(size: 16, color: AppColors.textSecondary)))
                : RefreshIndicator(
                    onRefresh: _loadData,
                    color: AppColors.primary,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        if (_guides.isNotEmpty) ...[
                          Text('Guides', style: AppTheme.headline(size: 16)),
                          const SizedBox(height: 12),
                          ..._guides.map((g) {
                            final profile = g['profiles'] ?? {};
                            final name = profile['name'] ?? 'Unknown Guide';
                            final location = profile['location'] ?? 'Unknown Location';
                            return _verificationCard('guide', g, name, location, _formatDate(g['submitted_at']), _countDocs(g), g['status']);
                          }),
                          const SizedBox(height: 16),
                        ],
                        if (_merchants.isNotEmpty) ...[
                          Text('Merchants', style: AppTheme.headline(size: 16)),
                          const SizedBox(height: 12),
                          ..._merchants.map((m) {
                            final profile = m['merchant_profiles'] ?? {};
                            final name = profile['businessName'] ?? 'Unknown Business';
                            final location = profile['address'] ?? 'Unknown Location';
                            return _verificationCard('merchant', m, name, location, _formatDate(m['submitted_at']), _countDocs(m), m['status']);
                          }),
                        ],
                      ],
                    ),
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _verificationCard(String type, Map<String, dynamic> data, String name, String city, String date, int docs, String status) {
    final id = type == 'guide' ? data['guide_id'] : data['merchant_id'];
    final isPending = status == 'submitted';
    final statusColor = status == 'approved' ? AppColors.success : AppColors.error;
    
    return GestureDetector(
      onTap: () => _openDetails(data, type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: AppShadows.card),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(radius: 22, backgroundColor: type == 'guide' ? AppColors.primary.withOpacity(0.15) : AppColors.accent.withOpacity(0.15), child: Icon(type == 'guide' ? Icons.person : Icons.store, color: type == 'guide' ? AppColors.primary : AppColors.accent)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: AppTheme.label(size: 14)),
              Text('$city · Submitted $date', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.touristBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Text('$docs docs', style: AppTheme.label(size: 10, color: AppColors.touristBlue))),
          ]),
          const SizedBox(height: 12),
          
          if (isPending) 
            Row(children: [
              Expanded(child: ElevatedButton(
                onPressed: () => _updateStatus(type, id, 'approved'), 
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 10)),
                child: const Text('Approve', style: TextStyle(fontSize: 13))
              )),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton(
                onPressed: () => _updateStatus(type, id, 'rejected'), 
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 10)),
                child: const Text('Reject', style: TextStyle(fontSize: 13))
              )),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _openDetails(data, type), 
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8)),
                child: const Text('Info', style: TextStyle(fontSize: 13))
              ),
            ])
          else
            Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  alignment: Alignment.center,
                  child: Text(status.toUpperCase(), style: AppTheme.label(size: 12, color: statusColor)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _openDetails(data, type), 
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8)),
                child: const Text('View', style: TextStyle(fontSize: 13))
              ),
            ])
        ]),
      ),
    );
  }
}
