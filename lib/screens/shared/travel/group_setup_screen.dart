import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../models/group_trip.dart';
import '../../../providers/travel_provider.dart';
import '../../../widgets/durie_mascot.dart';
import '../../../widgets/kuyog_back_button.dart';
import 'ai_matching_screen.dart';

class GroupSetupScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const GroupSetupScreen({super.key, required this.onContinue});

  @override
  State<GroupSetupScreen> createState() => _GroupSetupScreenState();
}

class _GroupSetupScreenState extends State<GroupSetupScreen> {
  final _groupNameCtrl = TextEditingController();
  bool _showPreview = false;

  @override
  void dispose() {
    _groupNameCtrl.dispose();
    super.dispose();
  }

  void _addMember() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddMemberSheet(
        onAdd: (member) {
          context.read<TravelProvider>().addMember(member);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onContinue(BuildContext context) {
    if (_groupNameCtrl.text.isNotEmpty) {
      context.read<TravelProvider>().setGroupName(_groupNameCtrl.text);
    }
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildGroupNameInput(),
                    const SizedBox(height: 24),
                    _buildTripLeaderCard(),
                    const SizedBox(height: 24),
                    _buildMembersSection(),
                    const SizedBox(height: 24),
                    _buildGroupSummary(),
                    const SizedBox(height: 24),
                    _buildInvitationPreview(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
      child: Row(
        children: [
          KuyogBackButton(onTap: () => Navigator.pop(context)),
          const SizedBox(width: 12),
          Text('Set Up Your Group', style: AppTheme.headline(size: 20)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const DurieMascot(size: 60),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Invite your travel companions!', style: AppTheme.headline(size: 18, color: AppColors.primary)),
              const SizedBox(height: 4),
              Text(
                'Add your group members\' details below. They\'ll receive an invite to join your trip.',
                style: AppTheme.body(size: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name your group trip', style: AppTheme.label(size: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: _groupNameCtrl,
          style: AppTheme.body(size: 15),
          maxLength: 60,
          decoration: InputDecoration(
            hintText: 'e.g. Barkada Davao Trip 2025',
          ),
        ),
      ],
    );
  }

  Widget _buildTripLeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Maria Santos', style: AppTheme.label(size: 16)),
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, size: 16, color: AppColors.verified),
                  ],
                ),
                Text('maria@example.com', style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text('Trip Leader (You)', style: AppTheme.label(size: 10, color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection() {
    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        final members = provider.members;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Group Members', style: AppTheme.headline(size: 18)),
                Text('${members.length} / 9 added', style: AppTheme.label(size: 13, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 16),
            ...members.asMap().entries.map((entry) {
              int idx = entry.key;
              GroupMember member = entry.value;
              return _buildMemberCard(member, idx, provider);
            }),
            if (members.length < 9) ...[
              OutlinedButton.icon(
                onPressed: _addMember,
                icon: const Icon(Icons.add),
                label: const Text('Add Member'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  // Mock import
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contacts imported!'), backgroundColor: AppColors.primary),
                  );
                },
                icon: const Icon(Icons.contacts, color: AppColors.textSecondary),
                label: Text('Import from Contacts', style: AppTheme.label(size: 14, color: AppColors.textSecondary)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: AppColors.divider),
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMemberCard(GroupMember member, int index, TravelProvider provider) {
    String initials = member.name.isNotEmpty ? member.name[0].toUpperCase() : '?';
    if (member.name.contains(' ')) {
      initials = member.name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryLight.withOpacity(0.2),
            child: Text(initials, style: AppTheme.label(size: 16, color: AppColors.primary)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(member.name, style: AppTheme.label(size: 15))),
                    InkWell(
                      onTap: () => provider.removeMember(index),
                      child: Text('Remove', style: AppTheme.label(size: 12, color: AppColors.error)),
                    ),
                  ],
                ),
                Text(member.email, style: AppTheme.body(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(member.role, style: AppTheme.label(size: 10, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, size: 10, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text('Invite Pending', style: AppTheme.label(size: 10, color: AppColors.warning)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSummary() {
    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        final count = provider.members.length + 1; // +1 for leader
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 40,
                child: Stack(
                  children: [
                    Positioned(left: 0, child: _avatarMock('M', AppColors.primary)),
                    if (provider.members.isNotEmpty) Positioned(left: 20, child: _avatarMock(provider.members[0].name[0], AppColors.accent)),
                    if (provider.members.length > 1) Positioned(left: 40, child: _avatarMock(provider.members[1].name[0], AppColors.touristBlue)),
                    if (provider.members.length > 2) Positioned(left: 60, child: CircleAvatar(backgroundColor: AppColors.divider, child: Text('+${provider.members.length - 2}', style: AppTheme.label(size: 12)))),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$count members ready', style: AppTheme.label(size: 14)),
                    Text('to join your trip', style: AppTheme.body(size: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _avatarMock(String initial, Color color) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 20,
      child: CircleAvatar(
        backgroundColor: color,
        radius: 18,
        child: Text(initial.toUpperCase(), style: AppTheme.label(size: 14, color: Colors.white)),
      ),
    );
  }

  Widget _buildInvitationPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _showPreview = !_showPreview),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Preview Invite Message', style: AppTheme.label(size: 14, color: AppColors.primary)),
              const SizedBox(width: 4),
              Icon(_showPreview ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.primary),
            ],
          ),
        ),
        if (_showPreview) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.mail_outline, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text('You\'re invited to join a trip!', style: AppTheme.label(size: 14)),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  'Maria Santos is planning a group trip to Mindanao and has added you as a travel companion.\n\n'
                  'Trip: ${_groupNameCtrl.text.isNotEmpty ? _groupNameCtrl.text : "Unnamed Trip"}\n'
                  'Dates: TBD\n'
                  'Guide Type: Community Guide\n\n'
                  'Tap below to accept the invite and join the trip ecosystem.',
                  style: AppTheme.body(size: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.pill)),
                      child: Text('Accept Invite →', style: AppTheme.label(size: 12, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _onContinue(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Send Invites & Continue',
                style: AppTheme.label(size: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _onContinue(context),
            child: Text('Skip for Now', style: AppTheme.label(size: 14, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _AddMemberSheet extends StatefulWidget {
  final Function(GroupMember) onAdd;

  const _AddMemberSheet({required this.onAdd});

  @override
  State<_AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<_AddMemberSheet> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String _role = 'Friend';
  final _roles = ['Friend', 'Family', 'Colleague', 'Partner', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add Member', style: AppTheme.headline(size: 20)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Full Name *', hintText: 'e.g. Juan dela Cruz'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email Address *', hintText: 'juan@example.com'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _role,
            decoration: const InputDecoration(labelText: 'Role'),
            items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
            onChanged: (v) => setState(() => _role = v!),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.isNotEmpty && _emailCtrl.text.isNotEmpty) {
                  widget.onAdd(GroupMember(
                    name: _nameCtrl.text,
                    email: _emailCtrl.text,
                    role: _role,
                    status: 'pending',
                  ));
                }
              },
              child: const Text('Add to Group'),
            ),
          ),
        ],
      ),
    );
  }
}
