import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/health_dashboard_controller.dart';

class SettingsScreen extends StatelessWidget {
  final HealthDashboardController controller;

  const SettingsScreen({super.key, required this.controller});

  void _showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset All Health Data?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will restore baseline risk factors, sample lab markers, and initial habit logs to default values.',
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetAll();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Database reset to defaults.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reset to Defaults'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Settings & Preferences',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Personalization & Scientific Longevity Engine',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 16),

          // Appearance Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appearance & Theme',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Dark Mode (Emerald Slate)', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('High-contrast medical dark theme', style: TextStyle(fontSize: 12)),
                  value: controller.isDarkTheme,
                  activeTrackColor: AppColors.primary,
                  activeThumbColor: AppColors.primaryLight,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (_) => controller.toggleTheme(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scientific Rationale Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: AppColors.secondary, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Evidence-Based Longevity Guidelines',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildEvidenceBullet(
                  'Sulforaphane & Cruciferous Vegetables',
                  'Induces Nrf2 phase-2 antioxidant pathways, enhancing cellular DNA repair and mitigating cardiovascular plaque drivers.',
                ),
                const SizedBox(height: 8),
                _buildEvidenceBullet(
                  'Ultra-Processed Food (UPF) Avoidance',
                  'Reduces systemic hs-CRP, eliminates emulsifier-mediated gut permeability, and preserves insulin sensitivity.',
                ),
                const SizedBox(height: 8),
                _buildEvidenceBullet(
                  'Continuous UV Index & Melanoma ABCDE',
                  '90% of non-melanoma and 86% of melanoma skin cancers are UV-associated. Early dermoscopic detection yields >99% 5-year survival.',
                ),
                const SizedBox(height: 8),
                _buildEvidenceBullet(
                  'Sedentary Interruption & Soleus Activation',
                  '5-minute walking/soleus muscle contractions every 45 minutes prevent venous stasis, clearing postprandial glucose by up to 52%.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Data Management Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data Management & Storage',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.restart_alt_rounded, color: AppColors.error),
                  title: const Text('Reset to Default Baseline Data', style: TextStyle(color: AppColors.error, fontSize: 14)),
                  subtitle: const Text('Restores default profile and sample habits', style: TextStyle(fontSize: 12)),
                  contentPadding: EdgeInsets.zero,
                  onTap: () => _showResetConfirmDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEvidenceBullet(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppColors.primaryLight),
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondaryDark, height: 1.35),
        ),
      ],
    );
  }
}
