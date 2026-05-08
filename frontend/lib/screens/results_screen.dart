// lib/screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class ResultsScreen extends StatelessWidget {
  final List<CourseRecommendation> recommendations;
  final String mode;
  final StudentProfile profile;
  final bool isMock;

  const ResultsScreen({
    super.key,
    required this.recommendations,
    required this.mode,
    required this.profile,
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
          // Background
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_accent.withOpacity(0.08), Colors.transparent],
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
                              Text(
                                'Demo Mode',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.amber,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: _accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: _accent.withOpacity(0.3)),
                              ),
                              child: Icon(
                                _isAI
                                    ? Icons.auto_awesome_rounded
                                    : Icons.account_tree_rounded,
                                color: _accent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recommendations',
                                  style: TextStyle(
                                    fontFamily: 'Syne',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'for ${profile.name}  ·  ${_isAI ? "AI Mode" : "Logic Mode"}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).animate().fadeIn().slideY(begin: -0.2),

                        const SizedBox(height: 24),

                        // Summary card
                        _SummaryCard(
                          profile: profile,
                          count: recommendations.length,
                          accent: _accent,
                        ).animate().fadeIn(delay: 150.ms),

                        const SizedBox(height: 28),

                        const SectionLabel('Your Matches'),
                        const SizedBox(height: 14),

                        // Recommendation cards
                        ...recommendations.asMap().entries.map((entry) {
                          final i = entry.key;
                          final rec = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _RecommendationCard(
                              rec: rec,
                              rank: i + 1,
                              accent: _accent,
                            )
                                .animate()
                                .fadeIn(delay: Duration(milliseconds: 200 + i * 100))
                                .slideX(begin: 0.1),
                          );
                        }),

                        const SizedBox(height: 28),

                        // Try other mode
                        GlowCard(
                          glowColor: _isAI ? AppColors.teal : AppColors.amber,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                _isAI
                                    ? Icons.account_tree_rounded
                                    : Icons.auto_awesome_rounded,
                                color: _isAI ? AppColors.teal : AppColors.amber,
                                size: 22,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Try ${_isAI ? "Logic" : "AI"} Mode',
                                      style: const TextStyle(
                                        fontFamily: 'Syne',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      _isAI
                                          ? 'Compare with rule-based Prolog reasoning'
                                          : 'Compare with AI-powered suggestions',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.textMuted,
                                size: 14,
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms),

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

// ── Summary card ──────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final StudentProfile profile;
  final int count;
  final Color accent;

  const _SummaryCard({
    required this.profile,
    required this.count,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _StatItem(value: '$count', label: 'Matches', color: accent),
          _Divider(),
          _StatItem(
            value: profile.interests.length.toString(),
            label: 'Interests',
            color: accent,
          ),
          _Divider(),
          _StatItem(
            value: '${profile.availableHoursPerWeek}h',
            label: 'Per Week',
            color: accent,
          ),
          _Divider(),
          _StatItem(
            value: profile.difficultyPreference[0].toUpperCase() +
                profile.difficultyPreference.substring(1),
            label: 'Level',
            color: accent,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 32, color: AppColors.border);
  }
}

// ── Recommendation card ───────────────────────────────────────
class _RecommendationCard extends StatefulWidget {
  final CourseRecommendation rec;
  final int rank;
  final Color accent;

  const _RecommendationCard({
    required this.rec,
    required this.rank,
    required this.accent,
  });

  @override
  State<_RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<_RecommendationCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final pct = (widget.rec.matchScore * 100).toInt();

    return GlowCard(
      glowColor: widget.accent,
      isSelected: widget.rank == 1,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rank badge
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.rank == 1
                      ? widget.accent.withOpacity(0.2)
                      : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.rank == 1
                        ? widget.accent
                        : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    '#${widget.rank}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: widget.rank == 1
                          ? widget.accent
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Course info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.rec.courseCode,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: widget.accent,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Spacer(),
                        DifficultyBadge(difficulty: widget.rec.difficulty),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.rec.courseName,
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.rec.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Match score bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Match Score',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  Text(
                    '$pct%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: widget.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: widget.rec.matchScore,
                  minHeight: 4,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(widget.accent),
                ),
              ),
            ],
          ),

          // Expandable reason + prerequisites
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: _expanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.border, height: 1),
                      const SizedBox(height: 14),
                      Text(
                        widget.rec.reason,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      if (widget.rec.prerequisites.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'PREREQUISITES',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.rec.prerequisites
                              .map((p) => ChipTag(
                                    label: p,
                                    color: AppColors.textSecondary,
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 10),

          // Expand toggle
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _expanded ? 'Show less' : 'Why this course?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.accent.withOpacity(0.8),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: widget.accent.withOpacity(0.8),
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}