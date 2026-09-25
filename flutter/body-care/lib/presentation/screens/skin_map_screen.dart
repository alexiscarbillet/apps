import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/mole_record_model.dart';
import '../../logic/health_dashboard_controller.dart';
import '../widgets/body_silhouette_widget.dart';
import '../widgets/mole_detail_sheet.dart';

class SkinMapScreen extends StatefulWidget {
  final HealthDashboardController controller;

  const SkinMapScreen({super.key, required this.controller});

  @override
  State<SkinMapScreen> createState() => _SkinMapScreenState();
}

class _SkinMapScreenState extends State<SkinMapScreen> {
  bool _isBackView = true;

  void _showMoleDetail(MoleRecord mole) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MoleDetailSheet(
        mole: mole,
        onUpdate: (updated) => widget.controller.updateMoleRecord(updated),
        onDelete: (id) => widget.controller.deleteMoleRecord(id),
      ),
    );
  }

  void _showAddMoleDialog({double? xPct, double? yPct, bool? backView}) {
    final labelCtrl = TextEditingController();
    final regionCtrl = TextEditingController(text: backView ?? _isBackView ? 'Upper Back' : 'Left Arm');
    final sizeCtrl = TextEditingController(text: '3.5');
    final notesCtrl = TextEditingController();
    bool isAsym = false;
    bool hasIrreg = false;
    bool hasMulti = false;
    bool isEvolving = false;
    MoleRiskRating selectedRisk = MoleRiskRating.monitor;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Log New Mole / Nevus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField(labelCtrl, 'Label / Name (e.g. Scapula Mole, Deltoid Nevus)'),
                const SizedBox(height: 8),
                _buildField(regionCtrl, 'Anatomical Region (e.g. Upper Back, Left Arm)'),
                const SizedBox(height: 8),
                _buildField(sizeCtrl, 'Diameter (mm)', isNumber: true),
                const SizedBox(height: 8),
                const Text('ABCDE Risk Flags:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                const SizedBox(height: 4),
                CheckboxListTile(
                  title: const Text('A - Asymmetry (Halves do not match)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  value: isAsym,
                  activeColor: AppColors.error,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => isAsym = v ?? false),
                ),
                CheckboxListTile(
                  title: const Text('B - Border Irregularity (Scalloped edges)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  value: hasIrreg,
                  activeColor: AppColors.error,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => hasIrreg = v ?? false),
                ),
                CheckboxListTile(
                  title: const Text('C - Color Variegation (Multiple shades)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  value: hasMulti,
                  activeColor: AppColors.error,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => hasMulti = v ?? false),
                ),
                CheckboxListTile(
                  title: const Text('E - Evolving (Changing over time)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  value: isEvolving,
                  activeColor: AppColors.error,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => isEvolving = v ?? false),
                ),
                const SizedBox(height: 8),
                const Text('Risk Assessment:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: MoleRiskRating.values.map((r) {
                    final isSel = selectedRisk == r;
                    return ChoiceChip(
                      label: Text(r.name.toUpperCase()),
                      selected: isSel,
                      selectedColor: AppColors.primary,
                      onSelected: (_) => setState(() => selectedRisk = r),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _buildField(notesCtrl, 'Dermatologist Notes / Appearance', maxLines: 2),
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
                if (labelCtrl.text.trim().isNotEmpty) {
                  final size = double.tryParse(sizeCtrl.text) ?? 3.0;
                  final mole = MoleRecord(
                    id: 'mole-${DateTime.now().millisecondsSinceEpoch}',
                    label: labelCtrl.text.trim(),
                    bodyRegion: regionCtrl.text.trim().isEmpty ? 'Upper Back' : regionCtrl.text.trim(),
                    isBackView: backView ?? _isBackView,
                    xPercent: xPct ?? 0.5,
                    yPercent: yPct ?? 0.35,
                    currentSizeMm: size,
                    baseColorHex: '#422818',
                    isAsymmetrical: isAsym,
                    hasIrregularBorder: hasIrreg,
                    hasMultipleColors: hasMulti,
                    isDiameterOver6mm: size >= 6.0,
                    isEvolving: isEvolving,
                    riskRating: selectedRisk,
                    lastCheckedDate: DateTime.now(),
                    clinicalNotes: notesCtrl.text.trim().isEmpty ? 'Baseline photo logged.' : notesCtrl.text.trim(),
                    history: [
                      MoleInspectionLog(
                        id: 'log-${DateTime.now().millisecondsSinceEpoch}',
                        date: DateTime.now(),
                        sizeMm: size,
                        notes: 'Initial baseline entry.',
                        photoSimColorHex: '#422818',
                      ),
                    ],
                  );
                  widget.controller.addMoleRecord(mole);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save Mole'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final moles = widget.controller.moleRecords;

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
                    'The Mole & Skin Map',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Visual Melanoma & Atypical Nevi Registry',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddMoleDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Mole'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // View Toggle (Anterior Front vs Posterior Back)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isBackView = false),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !_isBackView ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Anterior (Front Body)',
                        style: TextStyle(
                          color: !_isBackView ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isBackView = true),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isBackView ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Posterior (Back Body)',
                        style: TextStyle(
                          color: _isBackView ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 1. Interactive Anatomical Body Map
          SizedBox(
            height: 380,
            child: BodySilhouetteWidget(
              isBackView: _isBackView,
              moles: moles,
              onSelectMole: (mole) => _showMoleDetail(mole),
              onAddMoleAtCoordinates: (xPct, yPct, backView) {
                _showAddMoleDialog(xPct: xPct, yPct: yPct, backView: backView);
              },
            ),
          ),
          const SizedBox(height: 12),

          Center(
            child: Text(
              '💡 Tap anywhere on the body to drop a pin, or tap a pin to inspect',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Tracked Nevi List
          Text(
            'All Tracked Moles (${moles.length})',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...moles.map((mole) {
            Color riskColor = AppColors.success;
            if (mole.riskRating == MoleRiskRating.monitor) riskColor = const Color(0xFFFFB703);
            if (mole.riskRating == MoleRiskRating.doctorReview) riskColor = AppColors.error;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: riskColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mole.label,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '${mole.bodyRegion} (${mole.isBackView ? "Back" : "Front"}) • ${mole.currentSizeMm} mm • ${mole.history.length} photo logs',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primaryLight),
                    onPressed: () => _showMoleDetail(mole),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
