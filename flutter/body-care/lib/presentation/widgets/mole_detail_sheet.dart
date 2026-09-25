import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/mole_record_model.dart';

class MoleDetailSheet extends StatelessWidget {
  final MoleRecord mole;
  final Function(MoleRecord updatedMole) onUpdate;
  final Function(String id) onDelete;

  const MoleDetailSheet({
    super.key,
    required this.mole,
    required this.onUpdate,
    required this.onDelete,
  });

  void _showAddInspectionDialog(BuildContext context) {
    final sizeController = TextEditingController(text: mole.currentSizeMm.toString());
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Self-Inspection',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Measure diameter and record visual appearance:',
              style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: sizeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Diameter (mm)',
                labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Observations (color, border, symptoms)',
                labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                filled: true,
                fillColor: AppColors.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            onPressed: () {
              final newSize = double.tryParse(sizeController.text) ?? mole.currentSizeMm;
              final newLog = MoleInspectionLog(
                id: 'log-${DateTime.now().millisecondsSinceEpoch}',
                date: DateTime.now(),
                sizeMm: newSize,
                notes: notesController.text.trim().isEmpty
                    ? 'Periodic photo check: stable appearance.'
                    : notesController.text.trim(),
                photoSimColorHex: mole.baseColorHex,
              );

              final updatedHistory = List<MoleInspectionLog>.from(mole.history)..insert(0, newLog);
              final updated = mole.copyWith(
                currentSizeMm: newSize,
                lastCheckedDate: DateTime.now(),
                history: updatedHistory,
              );

              onUpdate(updated);
              Navigator.pop(ctx);
            },
            child: const Text('Save Inspection'),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor() {
    switch (mole.riskRating) {
      case MoleRiskRating.benign:
        return AppColors.success;
      case MoleRiskRating.monitor:
        return const Color(0xFFFFB703);
      case MoleRiskRating.doctorReview:
        return AppColors.error;
      case MoleRiskRating.biopsied:
        return const Color(0xFF8B5CF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskColor = _getRiskColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title & Risk Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mole.label,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Location: ${mole.bodyRegion} • ${mole.isBackView ? "Posterior" : "Anterior"}',
                        style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: riskColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    mole.riskRating.name.toUpperCase(),
                    style: TextStyle(
                      color: riskColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Visual Photo/Dermoscopy Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceDark),
              ),
              child: Row(
                children: [
                  // Simulated High-res Mole Swatch
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF24140D),
                          const Color(0xFF4A2A1A),
                          const Color(0xFF6B3E26),
                          const Color(0xFF8F5636).withValues(alpha: 0.1),
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                      border: Border.all(color: AppColors.surfaceDark, width: 2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${mole.currentSizeMm} mm Diameter',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Last checked: ${mole.lastCheckedDate.year}-${mole.lastCheckedDate.month.toString().padLeft(2, '0')}-${mole.lastCheckedDate.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          mole.clinicalNotes,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // ABCDE Criteria Evaluation Breakdown
            const Text(
              'Melanoma ABCDE Criteria Analysis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildAbcdeRow(
              letter: 'A',
              title: 'Asymmetry',
              isFlagged: mole.isAsymmetrical,
              desc: mole.isAsymmetrical ? 'One half does not match the other' : 'Symmetrical halves',
            ),
            _buildAbcdeRow(
              letter: 'B',
              title: 'Border Irregularity',
              isFlagged: mole.hasIrregularBorder,
              desc: mole.hasIrregularBorder ? 'Edges are scalloped or notched' : 'Smooth, even borders',
            ),
            _buildAbcdeRow(
              letter: 'C',
              title: 'Color Variegation',
              isFlagged: mole.hasMultipleColors,
              desc: mole.hasMultipleColors ? 'Multiple shades of brown/black/red' : 'Uniform color',
            ),
            _buildAbcdeRow(
              letter: 'D',
              title: 'Diameter > 6mm',
              isFlagged: mole.isDiameterOver6mm || mole.currentSizeMm >= 6.0,
              desc: mole.currentSizeMm >= 6.0 ? 'Exceeds 6mm (pencil eraser size)' : '< 6mm safe range',
            ),
            _buildAbcdeRow(
              letter: 'E',
              title: 'Evolving',
              isFlagged: mole.isEvolving,
              desc: mole.isEvolving ? 'Changing in size, shape or elevation' : 'Stable over time',
            ),
            const SizedBox(height: 18),

            // Inspection History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Inspection & Photo History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddInspectionDialog(context),
                  icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                  label: const Text('Log Check'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primaryLight),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...mole.history.map((log) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.photo_camera, color: AppColors.primaryLight, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')} • ${log.sizeMm} mm',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            log.notes,
                            style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
            // Actions: Delete
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      onDelete(mole.id);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                    label: const Text('Delete Mole', style: TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddInspectionDialog(context),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Log Check'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAbcdeRow({
    required String letter,
    required String title,
    required bool isFlagged,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isFlagged
                  ? AppColors.error.withValues(alpha: 0.2)
                  : AppColors.success.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isFlagged ? AppColors.error : AppColors.success,
              ),
            ),
            child: Text(
              letter,
              style: TextStyle(
                color: isFlagged ? AppColors.error : AppColors.success,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    color: isFlagged ? const Color(0xFFFCA5A5) : AppColors.textSecondaryDark,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isFlagged ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            size: 16,
            color: isFlagged ? AppColors.error : AppColors.success,
          ),
        ],
      ),
    );
  }
}
