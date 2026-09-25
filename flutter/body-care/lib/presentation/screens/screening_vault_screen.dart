import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/screening_model.dart';
import '../../logic/health_dashboard_controller.dart';
import '../widgets/screening_timeline_tile.dart';

class ScreeningVaultScreen extends StatefulWidget {
  final HealthDashboardController controller;

  const ScreeningVaultScreen({super.key, required this.controller});

  @override
  State<ScreeningVaultScreen> createState() => _ScreeningVaultScreenState();
}

class _ScreeningVaultScreenState extends State<ScreeningVaultScreen> {
  String _selectedFilter = 'All';

  void _showAddScreeningDialog() {
    final titleCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Preventative');
    final freqCtrl = TextEditingController(text: '12');
    final providerCtrl = TextEditingController();
    final facilityCtrl = TextEditingController();
    final whyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final prepCtrl = TextEditingController();
    DateTime nextDueDate = DateTime.now().add(const Duration(days: 90));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Medical Screening / Lab', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField(titleCtrl, 'Screening Name (e.g. Colonoscopy, Cardiac Echo)'),
                const SizedBox(height: 8),
                _buildField(categoryCtrl, 'Category (e.g. GI, Cardiology, Oncology)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildField(freqCtrl, 'Interval (months)', isNumber: true)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: nextDueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 3650)),
                          );
                          if (picked != null) {
                            setState(() => nextDueDate = picked);
                          }
                        },
                        child: Text(
                          'Due: ${nextDueDate.month}/${nextDueDate.day}/${nextDueDate.year}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildField(providerCtrl, 'Doctor / Provider Name'),
                const SizedBox(height: 8),
                _buildField(facilityCtrl, 'Clinic / Hospital Facility'),
                const SizedBox(height: 8),
                _buildField(whyCtrl, 'Preventative Importance & Rationale', maxLines: 2),
                const SizedBox(height: 8),
                _buildField(prepCtrl, 'Preparation Instructions (comma separated)', maxLines: 2),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty) {
                  final prepList = prepCtrl.text
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();
                  final sc = MedicalScreening(
                    id: 'sc-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    category: categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim(),
                    frequencyMonths: int.tryParse(freqCtrl.text) ?? 12,
                    nextDueDate: nextDueDate,
                    providerName: providerCtrl.text.trim(),
                    facility: facilityCtrl.text.trim(),
                    status: ScreeningStatus.upcoming,
                    notes: notesCtrl.text.trim(),
                    whyImportant: whyCtrl.text.trim().isEmpty
                        ? 'Essential early detection and risk mitigation.'
                        : whyCtrl.text.trim(),
                    prepChecklist: prepList,
                  );
                  widget.controller.addScreening(sc);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add Screening'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 13.5),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  void _markCompleted(MedicalScreening s) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      widget.controller.markScreeningCompleted(s.id, picked);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marked "${s.title}" as completed. Next due date updated!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allScreenings = widget.controller.screenings;

    final filtered = allScreenings.where((s) {
      if (_selectedFilter == 'Overdue') return s.isOverdue;
      if (_selectedFilter == 'Scheduled') return s.status == ScreeningStatus.scheduled;
      if (_selectedFilter == 'Completed') return s.status == ScreeningStatus.completed;
      if (_selectedFilter == 'Upcoming') return s.status == ScreeningStatus.upcoming;
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medical Screening Vault',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Timeline & Preventative Calendar',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showAddScreeningDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Upcoming', 'Scheduled', 'Completed', 'Overdue'].map((filter) {
                final isSel = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSel,
                    selectedColor: AppColors.primary,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Screening Timeline List
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 48, color: AppColors.textSecondaryDark.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text(
                    'No screenings found for "$_selectedFilter"',
                    style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                ],
              ),
            )
          else
            ...filtered.map((s) => ScreeningTimelineTile(
                  screening: s,
                  onMarkCompleted: () => _markCompleted(s),
                )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
