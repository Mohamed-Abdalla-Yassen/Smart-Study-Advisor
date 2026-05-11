// lib/screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class ResultsScreen extends StatefulWidget {
  final List<CourseResult> results;
  final StudentForm form;
  final String mode;
  final bool isMock;

  const ResultsScreen({
    super.key,
    required this.results,
    required this.form,
    required this.mode,
    this.isMock = false,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String _filterTier = 'All'; // 'All' | 'Tier 1' | 'Tier 2' | 'Tier 3' | 'Low'

  bool get _isAI  => widget.mode == 'ai';
  Color get _accent => _isAI ? AppColors.amber : AppColors.teal;

  List<CourseResult> get _filtered {
    if (_filterTier == 'All') return widget.results;
    return widget.results.where((c) {
      if (_filterTier == 'Low') return c.matchPercentage < 50;
      if (_filterTier == 'Tier 1') return c.matchPercentage == 100;
      if (_filterTier == 'Tier 2') return c.matchPercentage == 75;
      if (_filterTier == 'Tier 3') return c.matchPercentage == 50;
      return true;
    }).toList();
  }

  // Tier counts for the filter chips
  int _countForTier(String tier) {
    if (tier == 'All') return widget.results.length;
    if (tier == 'Low') return widget.results.where((c) => c.matchPercentage < 50).length;
    if (tier == 'Tier 1') return widget.results.where((c) => c.matchPercentage == 100).length;
    if (tier == 'Tier 2') return widget.results.where((c) => c.matchPercentage == 75).length;
    if (tier == 'Tier 3') return widget.results.where((c) => c.matchPercentage == 50).length;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
                // ── App bar ──────────────────────────────────────
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
                      if (widget.isMock)
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

                        // ── Header ───────────────────────────────
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
                                _isAI
                                    ? Icons.auto_awesome_rounded
                                    : Icons.account_tree_rounded,
                                color: _accent, size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Recommendations',
                                    style: TextStyle(fontFamily: 'Syne', fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                        letterSpacing: -0.5),
                                  ),
                                  Text(
                                    '${widget.form.dept}  ·  ${widget.form.prefs.join(", ")}',
                                    style: TextStyle(fontSize: 11, color: _accent,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).animate().fadeIn().slideY(begin: -0.2),

                        const SizedBox(height: 20),

                        // ── Stats bar ────────────────────────────
                        _StatsBar(
                          total: widget.results.length,
                          tier1: _countForTier('Tier 1'),
                          dept: widget.form.dept,
                          accent: _accent,
                        ).animate().fadeIn(delay: 100.ms),

                        const SizedBox(height: 20),

                        // ── Tier filter chips ────────────────────
                        _TierFilterRow(
                          selected: _filterTier,
                          accent: _accent,
                          counts: {
                            'All':    _countForTier('All'),
                            'Tier 1': _countForTier('Tier 1'),
                            'Tier 2': _countForTier('Tier 2'),
                            'Tier 3': _countForTier('Tier 3'),
                            'Low':    _countForTier('Low'),
                          },
                          onSelect: (t) => setState(() => _filterTier = t),
                        ).animate().fadeIn(delay: 150.ms),

                        const SizedBox(height: 24),

                        // ── Results list ─────────────────────────
                        if (filtered.isEmpty)
                          _EmptyState(accent: _accent)
                              .animate().fadeIn(delay: 200.ms)
                        else ...[
                          Row(
                            children: [
                              const SectionLabel('Matched Courses'),
                              const Spacer(),
                              Text('${filtered.length} shown',
                                style: TextStyle(fontSize: 11,
                                    color: _accent, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ...filtered.asMap().entries.map((e) {
                            final i = e.key;
                            final course = e.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _CourseCard(
                                course: course,
                                rank: i + 1,
                                accent: _accent,
                              ).animate()
                                  .fadeIn(delay: Duration(milliseconds: 200 + i * 50))
                                  .slideX(begin: 0.06),
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
  final int total, tier1;
  final String dept;
  final Color accent;

  const _StatsBar({
    required this.total, required this.tier1,
    required this.dept, required this.accent,
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
          _Stat(value: '$total', label: 'Total Found', color: accent),
          Container(width: 1, height: 30, color: AppColors.border),
          _Stat(value: '$tier1', label: 'Perfect Match', color: accent),
          Container(width: 1, height: 30, color: AppColors.border),
          _Stat(value: dept, label: 'Department', color: accent),
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
      child: Column(children: [
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
              color: AppColors.textMuted, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ── Tier filter row ───────────────────────────────────────────
class _TierFilterRow extends StatelessWidget {
  final String selected;
  final Color accent;
  final Map<String, int> counts;
  final void Function(String) onSelect;

  const _TierFilterRow({
    required this.selected, required this.accent,
    required this.counts, required this.onSelect,
  });

  Color _chipColor(String tier) {
    switch (tier) {
      case 'Tier 1': return AppColors.success;
      case 'Tier 2': return AppColors.amber;
      case 'Tier 3': return const Color(0xFF6C8EF5);
      case 'Low':    return AppColors.error;
      default:       return AppColors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiers = ['All', 'Tier 1', 'Tier 2', 'Tier 3', 'Low'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tiers.map((t) {
          final sel = selected == t;
          final color = _chipColor(t);
          return GestureDetector(
            onTap: () => onSelect(t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: sel ? color.withOpacity(0.15) : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: sel ? color : AppColors.border,
                    width: sel ? 1.5 : 1),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(t,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                      color: sel ? color : AppColors.textMuted)),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: sel ? color.withOpacity(0.2) : AppColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${counts[t] ?? 0}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                        color: sel ? color : AppColors.textMuted)),
                ),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Course card ───────────────────────────────────────────────
class _CourseCard extends StatelessWidget {
  final CourseResult course;
  final int rank;
  final Color accent;

  const _CourseCard({
    required this.course, required this.rank, required this.accent,
  });

  Color get _tierColor {
    final pct = course.matchPercentage;
    if (pct >= 100) return AppColors.success;
    if (pct >= 75)  return AppColors.amber;
    if (pct >= 50)  return const Color(0xFF6C8EF5);
    return AppColors.error;
  }

  Color get _difficultyColor {
    switch (course.difficulty) {
      case 'Easy':   return AppColors.success;
      case 'Hard':   return AppColors.error;
      default:       return AppColors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTop = rank == 1;
    final tierColor = _tierColor;

    return GlowCard(
      glowColor: tierColor,
      isSelected: isTop,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: rank + name + match badge ────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rank circle
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rank <= 3
                      ? tierColor.withOpacity(0.15)
                      : AppColors.surface,
                  border: Border.all(
                    color: rank <= 3 ? tierColor : AppColors.border,
                    width: isTop ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text('#$rank',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                        color: rank <= 3 ? tierColor : AppColors.textMuted)),
                ),
              ),
              const SizedBox(width: 12),

              // Course name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name,
                      style: const TextStyle(fontFamily: 'Syne', fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary, height: 1.3),
                    ),
                    const SizedBox(height: 4),
                    Text(course.department,
                      style: TextStyle(fontSize: 11, color: accent,
                          fontWeight: FontWeight.w600)),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Match % badge
              _MatchBadge(
                percentage: course.matchPercentage,
                color: tierColor,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Row 2: divider ───────────────────────────────────
          Divider(color: AppColors.border.withOpacity(0.5), height: 1),
          const SizedBox(height: 12),

          // ── Row 3: metadata chips ────────────────────────────
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              // Difficulty
              _MetaChip(
                icon: Icons.signal_cellular_alt_rounded,
                label: course.difficulty,
                color: _difficultyColor,
              ),

              // Year
              _MetaChip(
                icon: Icons.school_rounded,
                label: 'Year ${course.yearOfStudy}',
                color: accent,
              ),

              // Preference / interest
              _MetaChip(
                icon: Icons.label_rounded,
                label: course.preference,
                color: accent.withOpacity(0.8),
              ),

              // Prerequisite
              if (course.prerequisite != null)
                _MetaChip(
                  icon: Icons.lock_rounded,
                  label: 'Req: ${course.prerequisite}',
                  color: AppColors.textMuted,
                )
              else
                _MetaChip(
                  icon: Icons.lock_open_rounded,
                  label: 'No Prereq',
                  color: AppColors.success.withOpacity(0.7),
                ),
            ],
          ),

          // ── Tier label + TOP PICK badge ──────────────────────
          if (course.matchTier.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tierColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: tierColor.withOpacity(0.3)),
                ),
                child: Text(course.matchTier,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                      color: tierColor, letterSpacing: 0.3)),
              ),
              const Spacer(),
              if (isTop)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('TOP PICK',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                        color: accent, letterSpacing: 1)),
                ),
            ]),
          ],
        ],
      ),
    );
  }
}

// ── Match percentage circular badge ──────────────────────────
class _MatchBadge extends StatelessWidget {
  final double percentage;
  final Color color;
  const _MatchBadge({required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52, height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${percentage.toInt()}',
            style: TextStyle(fontFamily: 'Syne', fontSize: 15,
                fontWeight: FontWeight.w800, color: color, height: 1)),
          Text('%',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                color: color.withOpacity(0.7))),
        ],
      ),
    );
  }
}

// ── Small metadata chip ───────────────────────────────────────
class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetaChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ]),
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
        child: Column(children: [
          Icon(Icons.search_off_rounded, color: accent.withOpacity(0.4), size: 56),
          const SizedBox(height: 16),
          const Text('No courses found',
            style: TextStyle(fontFamily: 'Syne', fontSize: 20,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Try a different filter or adjust\nyour profile preferences.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
        ]),
      ),
    );
  }
}