import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/user_profile_model.dart';
import '../../logic/health_dashboard_controller.dart';
import '../widgets/why_tracker_banner.dart';

class RiskProfileScreen extends StatelessWidget {
  final HealthDashboardController controller;

  const RiskProfileScreen({super.key, required this.controller});

  void _showEditProfileDialog(BuildContext context) {
    final profile = controller.userProfile;
    final nameCtrl = TextEditingController(text: profile.fullName);
    final ageCtrl = TextEditingController(text: profile.age.toString());
    final heightCtrl = TextEditingController(text: profile.heightCm.toString());
    final weightCtrl = TextEditingController(text: profile.weightKg.toString());
    final rhrCtrl = TextEditingController(text: profile.restingHeartRate.toString());
    final sysCtrl = TextEditingController(text: profile.bloodPressureSystolic.toString());
    final diaCtrl = TextEditingController(text: profile.bloodPressureDiastolic.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Baseline Biomarkers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(nameCtrl, 'Full Name'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildDialogField(ageCtrl, 'Age', isNumber: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildDialogField(heightCtrl, 'Height (cm)', isNumber: true)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildDialogField(weightCtrl, 'Weight (kg)', isNumber: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildDialogField(rhrCtrl, 'Resting HR (bpm)', isNumber: true)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildDialogField(sysCtrl, 'Systolic BP', isNumber: true)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildDialogField(diaCtrl, 'Diastolic BP', isNumber: true)),
                ],
              ),
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
              final updated = profile.copyWith(
                fullName: nameCtrl.text.trim().isEmpty ? profile.fullName : nameCtrl.text.trim(),
                age: int.tryParse(ageCtrl.text) ?? profile.age,
                heightCm: double.tryParse(heightCtrl.text) ?? profile.heightCm,
                weightKg: double.tryParse(weightCtrl.text) ?? profile.weightKg,
                restingHeartRate: int.tryParse(rhrCtrl.text) ?? profile.restingHeartRate,
                bloodPressureSystolic: int.tryParse(sysCtrl.text) ?? profile.bloodPressureSystolic,
                bloodPressureDiastolic: int.tryParse(diaCtrl.text) ?? profile.bloodPressureDiastolic,
              );
              controller.updateUserProfile(updated);
              Navigator.pop(ctx);
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showAddRiskFactorDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Cardiovascular');
    final relationCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final mitigationsCtrl = TextEditingController();
    RiskLevel selectedLevel = RiskLevel.moderate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Genetic / Family Risk Factor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogField(titleCtrl, 'Condition / Risk Name (e.g. Coronary Plaque)'),
                const SizedBox(height: 8),
                _buildDialogField(categoryCtrl, 'Category (e.g. Cardiovascular, Metabolic, Oncology)'),
                const SizedBox(height: 8),
                _buildDialogField(relationCtrl, 'Family Relation (e.g. Father, Paternal Grandfather)'),
                const SizedBox(height: 8),
                const Text('Risk Level:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: RiskLevel.values.map((lvl) {
                    final isSel = selectedLevel == lvl;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(lvl.name.toUpperCase()),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        onSelected: (_) => setState(() => selectedLevel = lvl),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _buildDialogField(notesCtrl, 'Clinical Notes / Observations', maxLines: 2),
                const SizedBox(height: 8),
                _buildDialogField(mitigationsCtrl, 'Lifestyle Mitigations (comma separated)', maxLines: 2),
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
                  final mitigations = mitigationsCtrl.text
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();
                  final rf = RiskFactor(
                    id: 'rf-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    category: categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim(),
                    riskLevel: selectedLevel,
                    familyRelation: relationCtrl.text.trim(),
                    notes: notesCtrl.text.trim(),
                    mitigations: mitigations.isEmpty
                        ? ['Zone 2 cardio', 'Dietary leafy greens', 'Annual preventative screening']
                        : mitigations,
                  );
                  controller.addRiskFactor(rf);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add Risk Factor'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLabMarkerDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final valueCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'mg/dL');
    final rangeCtrl = TextEditingController(text: '< 100 mg/dL');
    final categoryCtrl = TextEditingController(text: 'Metabolic');
    final noteCtrl = TextEditingController();
    LabStatus selectedStatus = LabStatus.optimal;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Baseline Lab Biomarker', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogField(nameCtrl, 'Marker Name (e.g. ApoB, hs-CRP, Vitamin D)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildDialogField(valueCtrl, 'Value', isNumber: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildDialogField(unitCtrl, 'Unit (e.g. mg/dL, %)'))
                  ],
                ),
                const SizedBox(height: 8),
                _buildDialogField(rangeCtrl, 'Reference Range (e.g. < 80 mg/dL)'),
                const SizedBox(height: 8),
                _buildDialogField(categoryCtrl, 'Category (e.g. Cardiovascular, Metabolic)'),
                const SizedBox(height: 8),
                const Text('Status Rating:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: LabStatus.values.map((st) {
                    final isSel = selectedStatus == st;
                    return ChoiceChip(
                      label: Text(st.name.toUpperCase()),
                      selected: isSel,
                      selectedColor: AppColors.primary,
                      onSelected: (_) => setState(() => selectedStatus = st),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                _buildDialogField(noteCtrl, 'Clinical Interpretation Note', maxLines: 2),
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
                final val = double.tryParse(valueCtrl.text) ?? 0.0;
                if (nameCtrl.text.trim().isNotEmpty) {
                  final marker = LabMarker(
                    id: 'lab-${DateTime.now().millisecondsSinceEpoch}',
                    name: nameCtrl.text.trim(),
                    value: val,
                    unit: unitCtrl.text.trim(),
                    referenceRange: rangeCtrl.text.trim(),
                    status: selectedStatus,
                    dateRecorded: DateTime.now(),
                    category: categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim(),
                    clinicalNote: noteCtrl.text.trim().isEmpty ? 'Baseline recorded.' : noteCtrl.text.trim(),
                  );
                  controller.addLabMarker(marker);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add Biomarker'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogField(TextEditingController ctrl, String label, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
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
    final profile = controller.userProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Risk Dashboard',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Baseline Profile, Genetics & Biomarkers',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _showEditProfileDialog(context),
                icon: const Icon(Icons.edit, size: 14),
                label: const Text('Edit Bio'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Physical Baseline Grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${profile.fullName} • ${profile.age} yrs • ${profile.biologicalSex}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Type ${profile.bloodType}',
                        style: const TextStyle(color: AppColors.primaryLight, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildBioCard(context, label: 'BMI', value: profile.bmi.toStringAsFixed(1), unit: 'kg/m²', statusColor: AppColors.success),
                    const SizedBox(width: 8),
                    _buildBioCard(context, label: 'Resting HR', value: '${profile.restingHeartRate}', unit: 'bpm', statusColor: AppColors.primaryLight),
                    const SizedBox(width: 8),
                    _buildBioCard(context, label: 'Blood Pressure', value: '${profile.bloodPressureSystolic}/${profile.bloodPressureDiastolic}', unit: 'mmHg', statusColor: AppColors.success),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. The "Why" Tracker Banner
          WhyTrackerBanner(
            profile: profile,
            onEditWhy: (newWhy) => controller.updatePersonalWhy(newWhy),
          ),
          const SizedBox(height: 20),

          // 3. Family Medical History & Genetic Predispositions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.family_restroom_rounded, color: AppColors.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Family History & Genetic Risks',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryLight),
                onPressed: () => _showAddRiskFactorDialog(context),
                tooltip: 'Add Risk Factor',
              ),
            ],
          ),
          const SizedBox(height: 8),

          ...profile.riskFactors.map((rf) => _buildRiskFactorTile(context, rf)),

          const SizedBox(height: 20),

          // 4. Baseline Lab Biomarkers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.science_rounded, color: Color(0xFF8B5CF6), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Baseline Lab Biomarkers',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryLight),
                onPressed: () => _showAddLabMarkerDialog(context),
                tooltip: 'Add Lab Marker',
              ),
            ],
          ),
          const SizedBox(height: 8),

          ...profile.baselineLabs.map((lab) => _buildLabMarkerTile(context, lab)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBioCard(BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required Color statusColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskFactorTile(BuildContext context, RiskFactor rf) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color badgeColor = AppColors.success;
    if (rf.riskLevel == RiskLevel.moderate) badgeColor = AppColors.warning;
    if (rf.riskLevel == RiskLevel.high) badgeColor = AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  rf.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${rf.riskLevel.name.toUpperCase()} RISK',
                  style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Lineage: ${rf.familyRelation} • ${rf.category}',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          if (rf.notes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              rf.notes,
              style: const TextStyle(fontSize: 12.5, height: 1.3),
            ),
          ],
          const SizedBox(height: 10),
          const Text(
            'Active Preventative Protocols:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
          ),
          const SizedBox(height: 4),
          ...rf.mitigations.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.primaryLight, fontSize: 12)),
                    Expanded(
                      child: Text(
                        m,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildLabMarkerTile(BuildContext context, LabMarker lab) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color statusColor = AppColors.success;
    if (lab.status == LabStatus.borderline) statusColor = AppColors.warning;
    if (lab.status == LabStatus.needsAttention) statusColor = AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.surfaceDark.withValues(alpha: 0.5) : AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lab.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'Ref: ${lab.referenceRange}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${lab.value} ${lab.unit}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      lab.status.name.toUpperCase(),
                      style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (lab.clinicalNote.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              lab.clinicalNote,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
