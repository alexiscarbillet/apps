import 'package:flutter/material.dart';
import 'category_selection_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic styling definitions for our 8 categories
    final List<Map<String, dynamic>> categoryConfigs = [
      {
        'name': 'AWS',
        'description': 'Cloud computing, IAM, databases, and core AWS services.',
        'icon': Icons.cloud_done_outlined,
        'gradient': [const Color(0xFFFF9900), const Color(0xFFFF5E00)],
      },
      {
        'name': 'GCP',
        'description': 'Google Cloud Platform, GKE, BigQuery, and IAM roles.',
        'icon': Icons.cloud_circle_outlined,
        'gradient': [const Color(0xFF4285F4), const Color(0xFF34A853)],
      },
      {
        'name': 'Azure',
        'description': 'Enterprise services, Cosmos DB, Entra ID, and VNets.',
        'icon': Icons.lan_outlined,
        'gradient': [const Color(0xFF0078D4), const Color(0xFF00BFFF)],
      },
      {
        'name': 'AI',
        'description': 'ML algorithms, neural networks, transformers, and bias.',
        'icon': Icons.psychology_outlined,
        'gradient': [const Color(0xFF8B5CF6), const Color(0xFFD946EF)],
      },
      {
        'name': 'Kubernetes',
        'description': 'Container orchestration, pods, deployments, and scheduling.',
        'icon': Icons.dns_outlined,
        'gradient': [const Color(0xFF326CE5), const Color(0xFF00F5FF)],
      },
      {
        'name': 'Hardware',
        'description': 'CPU cache, memory, SSD architectures, and chipsets.',
        'icon': Icons.memory_outlined,
        'gradient': [const Color(0xFF64748B), const Color(0xFF334155)],
      },
      {
        'name': 'Network',
        'description': 'OSI model layers, DNS, routing protocols, and NAT.',
        'icon': Icons.router_outlined,
        'gradient': [const Color(0xFF0D9488), const Color(0xFF10B981)],
      },
      {
        'name': 'Electricity',
        'description': 'Circuits, Ohm\'s law, AC/DC, diodes, and voltage.',
        'icon': Icons.bolt_outlined,
        'gradient': [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
      },
      {
        'name': 'Python',
        'description': 'Object-oriented programming, data structures, and decorators.',
        'icon': Icons.code_outlined,
        'gradient': [const Color(0xFF3776AB), const Color(0xFFFFD43B)],
      },
      {
        'name': 'Bash',
        'description': 'Shell scripting, pipes, redirections, and command-line execution.',
        'icon': Icons.terminal_outlined,
        'gradient': [const Color(0xFF10B981), const Color(0xFF047857)],
      },
      {
        'name': 'Linux',
        'description': 'Filesystems, permissions, process management, and system administration.',
        'icon': Icons.computer_outlined,
        'gradient': [const Color(0xFF64748B), const Color(0xFF1E293B)],
      },
      {
        'name': 'SQL',
        'description': 'Relational databases, queries, joins, indexes, and transactions.',
        'icon': Icons.storage_outlined,
        'gradient': [const Color(0xFF336791), const Color(0xFF475569)],
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
                            'LearnIt Quiz',
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
                        'Boost your knowledge across cloud, networks, hardware, and engineering.',
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
