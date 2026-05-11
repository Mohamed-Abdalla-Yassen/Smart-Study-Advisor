// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'advisor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMode; // 'ai' | 'logic'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: Stack(
        children: [
          // ── Decorative background grid ──────────────────────
          _BackgroundGrid(),

          // ── Main content ────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.teal.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.teal,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Version 1.0',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.teal,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.2),

                  const SizedBox(height: 24),

                  // Title
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Smart\n',
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.05,
                            letterSpacing: -2,
                          ),
                        ),
                        TextSpan(
                          text: 'Study Advisor',
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: AppColors.teal,
                            height: 1.05,
                            letterSpacing: -2,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                  const SizedBox(height: 16),

                  const Text(
                    'Intelligent course recommendations powered by\nAI and logic programming paradigms.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(delay: 350.ms),

                  const SizedBox(height: 48),

                  // Mode selector label
                  const SectionLabel('Choose your advisor mode'),
                  const SizedBox(height: 16),

                  // AI Mode card
                  _ModeCard(
                    isSelected: _selectedMode == 'ai',
                    mode: 'ai',
                    icon: Icons.auto_awesome_rounded,
                    title: 'AI Advisor',
                    subtitle: 'Powered by Gemini via Django',
                    description: 'Uses large language models to reason about your academic profile and generate personalized recommendations.',
                    accentColor: AppColors.amber,
                    tags: const ['Gemini API', 'Natural Language', 'Contextual'],
                    onTap: () => setState(() => _selectedMode = 'ai'),
                  ).animate().fadeIn(delay: 450.ms).slideX(begin: -0.1),

                  const SizedBox(height: 14),

                  // Logic Mode card
                  _ModeCard(
                    isSelected: _selectedMode == 'logic',
                    mode: 'logic',
                    icon: Icons.account_tree_rounded,
                    title: 'Logic Advisor',
                    subtitle: 'Prolog inference via Django',
                    description: 'Uses formal logical rules and Prolog inference to deduce the best courses based on prerequisites and preferences.',
                    accentColor: AppColors.teal,
                    tags: const ['Prolog Engine', 'Rule-Based', 'Deterministic'],
                    onTap: () => setState(() => _selectedMode = 'logic'),
                  ).animate().fadeIn(delay: 550.ms).slideX(begin: -0.1),

                  const SizedBox(height: 40),

                  // Architecture diagram
                  _ArchitectureDiagram(mode: _selectedMode),

                  const SizedBox(height: 40),

                  // CTA button
                  NeonButton(
                    label: 'Get Recommendations',
                    icon: Icons.arrow_forward_rounded,
                    fullWidth: true,
                    color: _selectedMode == 'ai' ? AppColors.amber : AppColors.teal,
                    onPressed: _selectedMode == null
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdvisorScreen(mode: _selectedMode!),
                              ),
                            ),
                  ).animate().fadeIn(delay: 700.ms),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mode Card ─────────────────────────────────────────────────
class _ModeCard extends StatelessWidget {
  final bool isSelected;
  final String mode;
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color accentColor;
  final List<String> tags;
  final VoidCallback onTap;

  const _ModeCard({
    required this.isSelected,
    required this.mode,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.tags,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      glowColor: accentColor,
      isSelected: isSelected,
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: accentColor, size: 18),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags
                      .map((t) => ChipTag(label: t, color: accentColor))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Architecture Diagram ──────────────────────────────────────
class _ArchitectureDiagram extends StatelessWidget {
  final String? mode;
  const _ArchitectureDiagram({this.mode});

  @override
  Widget build(BuildContext context) {
    final color = mode == 'ai' ? AppColors.amber : AppColors.teal;
    final steps = mode == 'ai'
        ? ['Flutter App', 'Django REST', 'Gemini API', 'Response']
        : ['Flutter App', 'Django REST', 'Prolog Engine', 'Response'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('System Pipeline'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                return Icon(Icons.chevron_right_rounded,
                    color: color.withOpacity(0.5), size: 20);
              }
              final idx = i ~/ 2;
              return _PipelineStep(
                label: steps[idx],
                color: color,
                isFirst: idx == 0,
                isLast: idx == steps.length - 1,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _PipelineStep extends StatelessWidget {
  final String label;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const _PipelineStep({
    required this.label,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: (isFirst || isLast)
                ? color.withOpacity(0.2)
                : AppColors.surfaceElevated,
            shape: BoxShape.circle,
            border: Border.all(
              color: (isFirst || isLast) ? color : AppColors.border,
              width: isFirst ? 2 : 1,
            ),
          ),
          child: Icon(
            isFirst
                ? Icons.smartphone_rounded
                : isLast
                    ? Icons.check_rounded
                    : Icons.hub_rounded,
            color: (isFirst || isLast) ? color : AppColors.textSecondary,
            size: 16,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: (isFirst || isLast) ? color : AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Background Grid ───────────────────────────────────────────
class _BackgroundGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(painter: _GridPainter()),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.4)
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Glow blob top-right
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.teal.withOpacity(0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width, 0), radius: size.width * 0.6));
    canvas.drawCircle(Offset(size.width, 0), size.width * 0.6, glowPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}