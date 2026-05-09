// lib/screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class ResultsScreen extends StatelessWidget {
  final List<CourseResult> results;
  final StudentQuery query;
  final String mode;
  final bool isMock;

  const ResultsScreen({
    super.key,
    required this.results,
    required this.query,
    required this.mode,
    this.isMock = false,
  });

  bool get _isAI => mode == 'ai';
  Color get _accent => _isAI ? AppColors.amber : AppColors.teal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: Stack(
        children: [
          // Glow blob
          Positioned(
            top: -80, right: -80,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_accent.withOpacity(0.07), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── App bar ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      if (isMock)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.amberSoft,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.amber.withOpacity(0.4)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  color: AppColors.amber, size: 12),
                              SizedBox(width: 6),
                              Text('Demo Mode',
                                  style: TextStyle(fontSize: 11,
                                      color: AppColors.amber,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: _accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _accent.withOpacity(0.3)),
                              ),
                              child: Icon(
                                _isAI ? Icons.auto_awesome_rounded : Icons.account_tree_rounded,
                                color: _accent, size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Recommendations',
                                    style: TextStyle(fontFamily: 'Syne', fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                        letterSpacing: -0.5),
                                  ),
                                  Text(
                                    '${query.dept}  ·  ${query.pref}  ·  ${query.difficulty}  ·  Year ${query.year}',
                                    style: TextStyle(fontSize: 11, color: _accent,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).animate().fadeIn().slideY(begin: -0.2),

                        const SizedBox(height: 20),

                        // Stats bar
                        _StatsBar(
                          count: results.length,
                          dept: query.dept,
                          pref: query.pref,
                          accent: _accent,
                        ).animate().fadeIn(delay: 150.ms),

                        const SizedBox(height: 24),

                        // Results
                        if (results.isEmpty)
                          _EmptyState(accent: _accent)
                              .animate().fadeIn(delay: 200.ms)
                        else ...[
                          const SectionLabel('Matched Courses'),
                          const SizedBox(height: 14),
                          ...results.asMap().entries.map((e) {
                            final i = e.key;
                            final course = e.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _CourseCard(
                                name: course.name,
                                rank: i + 1,
                                accent: _accent,
                                dept: query.dept,
                              ).animate()
                                  .fadeIn(delay: Duration(milliseconds: 200 + i * 60))
                                  .slideX(begin: 0.08),
                            );
                          }),
                        ],

                        const SizedBox(height: 48),
                      ],
                    ),
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

// ── Stats bar ─────────────────────────────────────────────────
class _StatsBar extends StatelessWidget {
  final int count;
  final String dept, pref;
  final Color accent;

  const _StatsBar({
    required this.count, required this.dept,
    required this.pref, required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _Stat(value: '$count', label: 'Courses', color: accent),
          Container(width: 1, height: 30, color: AppColors.border),
          _Stat(value: dept, label: 'Department', color: accent),
          Container(width: 1, height: 30, color: AppColors.border),
          _Stat(value: pref, label: 'Interest', color: accent),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _Stat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Syne', fontSize: 15,
                fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 2),
          Text(label,
            style: const TextStyle(fontSize: 10,
                color: AppColors.textMuted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── Course card ───────────────────────────────────────────────
class _CourseCard extends StatelessWidget {
  final String name;
  final int rank;
  final Color accent;
  final String dept;

  const _CourseCard({
    required this.name, required this.rank,
    required this.accent, required this.dept,
  });

  // Derive a category label from the course name for display
  String get _tag {
    final n = name.toLowerCase();
    if (n.contains('advanced')) return 'Advanced';
    if (n.contains('introduction') || n.contains('intro')) return 'Intro';
    if (n.contains('applied')) return 'Applied';
    if (n.contains('experimental')) return 'Experimental';
    if (n.contains('computational')) return 'Computational';
    if (n.contains('theoretical')) return 'Theoretical';
    if (n.contains('fundamentals')) return 'Fundamentals';
    if (n.contains('principles')) return 'Principles';
    if (n.contains('contemporary')) return 'Contemporary';
    return dept;
  }

  @override
  Widget build(BuildContext context) {
    final isTop = rank <= 3;
    return GlowCard(
      glowColor: accent,
      isSelected: rank == 1,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Rank circle
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTop ? accent.withOpacity(0.15) : AppColors.surface,
              border: Border.all(
                color: isTop ? accent : AppColors.border,
                width: rank == 1 ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text('#$rank',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                    color: isTop ? accent : AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Course name + tag
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                  style: const TextStyle(fontFamily: 'Syne', fontSize: 15,
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                      height: 1.3),
                ),
                const SizedBox(height: 4),
                ChipTag(label: _tag, color: accent),
              ],
            ),
          ),

          // Top badge
          if (rank == 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('TOP PICK',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                    color: accent, letterSpacing: 1),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final Color accent;
  const _EmptyState({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, color: accent.withOpacity(0.4), size: 56),
            const SizedBox(height: 16),
            const Text('No courses found',
              style: TextStyle(fontFamily: 'Syne', fontSize: 20,
                  fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text('Try changing the difficulty, year\nor prerequisite filter.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}