import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/health_dashboard_controller.dart';
import '../widgets/uv_meter_gauge.dart';

class EnvironmentScreen extends StatelessWidget {
  final HealthDashboardController controller;

  const EnvironmentScreen({super.key, required this.controller});

  static const List<Map<String, dynamic>> presetLocations = [
    {'name': 'Montreal, QC', 'lat': 45.5017, 'lon': -73.5673},
    {'name': 'Paris, France', 'lat': 48.8566, 'lon': 2.3522},
    {'name': 'New York, USA', 'lat': 40.7128, 'lon': -74.0060},
    {'name': 'San Francisco, USA', 'lat': 37.7749, 'lon': -122.4194},
    {'name': 'Sydney, Australia', 'lat': -33.8688, 'lon': 151.2093},
    {'name': 'Tokyo, Japan', 'lat': 35.6762, 'lon': 139.6503},
    {'name': 'London, UK', 'lat': 51.5074, 'lon': -0.1278},
  ];

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select City for Live UV Index',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...presetLocations.map((loc) {
              final isCurrent = controller.uvData.locationName == loc['name'];
              return ListTile(
                leading: Icon(
                  Icons.location_city,
                  color: isCurrent ? AppColors.primaryLight : AppColors.textSecondaryDark,
                ),
                title: Text(
                  loc['name'] as String,
                  style: TextStyle(
                    color: isCurrent ? AppColors.primaryLight : Colors.white,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isCurrent ? const Icon(Icons.check, color: AppColors.primaryLight) : null,
                onTap: () {
                  controller.updateLocation(
                    name: loc['name'] as String,
                    latitude: loc['lat'] as double,
                    longitude: loc['lon'] as double,
                  );
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final uv = controller.uvData;

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
                    'UV & Environmental Log',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Photo-aging & Melanoma Prevention',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _showLocationPicker(context),
                icon: const Icon(Icons.location_on, size: 14),
                label: const Text('City'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Live UV Meter Gauge
          UvMeterGauge(
            uvData: uv,
            onLogSunscreen: () => controller.logSunscreenApplication(),
            onRefresh: () => controller.refreshUvData(),
          ),
          const SizedBox(height: 18),

          // 2. Solar Radiation Breakdown
          Text(
            'Solar Radiation & Skin Risk Profile',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
            ),
            child: Column(
              children: [
                _buildEnvRow(
                  context,
                  icon: Icons.wb_sunny_rounded,
                  label: 'UVA Radiation (Aging & DNA mutation)',
                  value: 'Consistent year-round',
                  desc: 'Penetrates deep into dermis; responsible for cross-linking collagen and matrix metalloproteinase induction.',
                ),
                const Divider(height: 20),
                _buildEnvRow(
                  context,
                  icon: Icons.flare_rounded,
                  label: 'UVB Radiation (Sunburn & Erythema)',
                  value: uv.currentUv >= 3.0 ? 'Elevated' : 'Low',
                  desc: 'Directly creates cyclobutane pyrimidine dimers (CPDs) in keratinocyte DNA. Peak between 11 AM - 3 PM.',
                ),
                const Divider(height: 20),
                _buildEnvRow(
                  context,
                  icon: Icons.air_rounded,
                  label: 'Ambient Air Quality (AQI)',
                  value: 'Good (Index 1)',
                  desc: 'Low particulate matter PM2.5 minimizes external oxidative skin barrier stress.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 3. Preventative Sun Defense Protocol
          Text(
            'Dermatologist-Approved Sun Defense Protocol',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildProtocolCard(
            context,
            number: '1',
            title: 'Broad-Spectrum Mineral Sunscreen',
            subtitle: 'Zinc Oxide (15-20%) or Titanium Dioxide',
            desc: 'Provides physical photon reflection against both UVA1/UVA2 and UVB without endocrine disrupting chemical filters.',
          ),
          const SizedBox(height: 10),

          _buildProtocolCard(
            context,
            number: '2',
            title: 'The 2-Hour Reapplication Rule',
            subtitle: 'Crucial when outdoors or sweating',
            desc: 'UV filters degrade under photon exposure and friction. Reapplying ensures continuous minimal erythemal dose protection.',
          ),
          const SizedBox(height: 10),

          _buildProtocolCard(
            context,
            number: '3',
            title: 'UV400 Polarized Eye Protection',
            subtitle: 'Blocks 100% of UVA and UVB rays',
            desc: 'Protects against ocular melanoma, macular degeneration, and lens cataracts.',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEnvRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String desc,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.secondary, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          desc,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildProtocolCard(
    BuildContext context, {
    required String number,
    required String title,
    required String subtitle,
    required String desc,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
