import 'package:flutter/material.dart';
import 'category_selection_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Organize electricity into focused tracks for progressive study.
    final List<Map<String, dynamic>> categoryConfigs = [
      {
        'name': 'Electrical Foundations',
        'description': 'Voltage, current, resistance, power, and core electrical units.',
        'icon': Icons.bolt_outlined,
        'gradient': [const Color(0xFFF59E0B), const Color(0xFFEA580C)],
      },
      {
        'name': 'Circuit Analysis',
        'description': 'Series, parallel, Kirchhoff laws, filters, and equivalent circuits.',
        'icon': Icons.account_tree_outlined,
        'gradient': [const Color(0xFF0EA5E9), const Color(0xFF2563EB)],
      },
      {
        'name': 'AC/DC & Power',
        'description': 'Waveforms, rectifiers, transformers, frequency, and power factor.',
        'icon': Icons.electrical_services_outlined,
        'gradient': [const Color(0xFFEAB308), const Color(0xFFCA8A04)],
      },
      {
        'name': 'Components & Semiconductors',
        'description': 'Resistors, capacitors, inductors, diodes, LEDs, and transistors.',
        'icon': Icons.memory_outlined,
        'gradient': [const Color(0xFFA855F7), const Color(0xFF7C3AED)],
      },
      {
        'name': 'Wiring & Canadian Regulations',
        'description': 'CEC context, wire types, ampacity, bonding, GFCI, and AFCI.',
        'icon': Icons.construction_outlined,
        'gradient': [const Color(0xFF14B8A6), const Color(0xFF0F766E)],
      },
      {
        'name': 'Safety & Applications',
        'description': 'Safe work practices, motors, solar systems, batteries, and lighting.',
        'icon': Icons.health_and_safety_outlined,
        'gradient': [const Color(0xFF22C55E), const Color(0xFF15803D)],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Slate dark background
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Premium Header with Title and Subtitle
            SliverAppBar(
              floating: true,
              expandedHeight: 180.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Colors.blueAccent,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Learn Electricity',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Build confidence with circuits, wiring, power systems, and electrical safety.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94A3B8),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Grid of Category Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.85, // Adjust for nice card height
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final config = categoryConfigs[index];
                    final categoryName = config['name'] as String;
                    final List<Color> gradient = config['gradient'] as List<Color>;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategorySelectionScreen(
                              category: categoryName,
                              description: config['description'] as String,
                              icon: config['icon'] as IconData,
                              gradient: gradient,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B), // Card background
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradient.first.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // Subtle background glow/decoration
                            Positioned(
                              top: -40,
                              right: -40,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      gradient.first.withValues(alpha: 0.2),
                                      gradient.first.withValues(alpha: 0),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Card Contents
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon with gradient background
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: gradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      config['icon'] as IconData,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const Spacer(),

                                  // Category Title
                                  Text(
                                    categoryName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Category Description
                                  Text(
                                    config['description'] as String,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),

                            // Glow Accent Line on Card Top
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradient,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: categoryConfigs.length,
                ),
              ),
            ),

            // Add a little bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}
