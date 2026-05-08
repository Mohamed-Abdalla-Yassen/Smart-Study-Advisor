// lib/screens/advisor_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'results_screen.dart';

class AdvisorScreen extends StatefulWidget {
  final String mode; // 'ai' | 'logic'
  const AdvisorScreen({super.key, required this.mode});

  @override
  State<AdvisorScreen> createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();

  String _difficulty = 'medium';
  int _hoursPerWeek = 10;
  bool _isLoading = false;

  final List<String> _interests = [];
  final List<String> _completedCourses = [];
  final _interestController = TextEditingController();
  final _courseController = TextEditingController();

  // Available interest options
  static const _interestOptions = [
    'Artificial Intelligence', 'Machine Learning', 'Web Development',
    'Systems Programming', 'Data Science', 'Computer Vision',
    'Networking', 'Security', 'Algorithms', 'Embedded Systems',
  ];

  bool get _isAI => widget.mode == 'ai';
  Color get _accent => _isAI ? AppColors.amber : AppColors.teal;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _interestController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name.');
      return;
    }
    if (_interests.isEmpty) {
      _showError('Add at least one interest.');
      return;
    }

    setState(() => _isLoading = true);

    final profile = StudentProfile(
      name: _nameController.text.trim(),
      studentId: _idController.text.trim(),
      completedCourses: _completedCourses,
      interests: _interests,
      difficultyPreference: _difficulty,
      availableHoursPerWeek: _hoursPerWeek,
    );

    try {
      final results = _isAI
          ? await ApiService.getAIRecommendations(profile)
          : await ApiService.getLogicRecommendations(profile);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              recommendations: results,
              mode: widget.mode,
              profile: profile,
            ),
          ),
        );
      }
    } catch (e) {
      // Use mock data if backend isn't running yet (demo mode)
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              recommendations: CourseRecommendation.mockResults(),
              mode: widget.mode,
              profile: profile,
              isMock: true,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: _accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              _isAI ? 'AI Advisor' : 'Logic Advisor',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _accent,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Page header
            const Text(
              'Build your\nProfile',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.1,
                letterSpacing: -1.5,
              ),
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 6),
            const Text(
              'The more you share, the better your recommendations.',
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 36),

            // ── Section: Identity ──────────────────────────────
            const SectionLabel('Identity'),
            const SizedBox(height: 12),
            _StyledTextField(
              controller: _nameController,
              hint: 'Your full name',
              icon: Icons.person_outline_rounded,
              accent: _accent,
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 10),
            _StyledTextField(
              controller: _idController,
              hint: 'Student ID  (optional)',
              icon: Icons.badge_outlined,
              accent: _accent,
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 28),

            // ── Section: Interests ─────────────────────────────
            const SectionLabel('Academic Interests'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _interestOptions.map((opt) {
                final selected = _interests.contains(opt);
                return GestureDetector(
                  onTap: () => setState(() {
                    selected ? _interests.remove(opt) : _interests.add(opt);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? _accent.withOpacity(0.15)
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            selected ? _accent : AppColors.border,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected ? _accent : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 250.ms),

            const SizedBox(height: 28),

            // ── Section: Completed Courses ─────────────────────
            const SectionLabel('Completed Courses'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StyledTextField(
                    controller: _courseController,
                    hint: 'e.g. CSE-201',
                    icon: Icons.school_outlined,
                    accent: _accent,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    final v = _courseController.text.trim().toUpperCase();
                    if (v.isNotEmpty && !_completedCourses.contains(v)) {
                      setState(() {
                        _completedCourses.add(v);
                        _courseController.clear();
                      });
                    }
                  },
                  child: Container(
                    width: 48,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _accent.withOpacity(0.4)),
                    ),
                    child: Icon(Icons.add_rounded, color: _accent),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms),
            if (_completedCourses.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _completedCourses
                    .map((c) => ChipTag(
                          label: c,
                          color: _accent,
                          onRemove: () =>
                              setState(() => _completedCourses.remove(c)),
                        ))
                    .toList(),
              ),
            ],

            const SizedBox(height: 28),

            // ── Section: Preferences ───────────────────────────
            const SectionLabel('Preferences'),
            const SizedBox(height: 16),

            // Difficulty
            GlowCard(
              glowColor: _accent,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preferred Difficulty',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: ['easy', 'medium', 'hard'].map((d) {
                      final selected = _difficulty == d;
                      final color = d == 'easy'
                          ? AppColors.success
                          : d == 'hard'
                              ? AppColors.error
                              : AppColors.amber;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _difficulty = d),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? color.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selected
                                    ? color
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              d[0].toUpperCase() + d.substring(1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? color
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 350.ms),

            const SizedBox(height: 12),

            // Hours per week slider
            GlowCard(
              glowColor: _accent,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hours per week',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '$_hoursPerWeek hrs',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _accent,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: _accent,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: _accent,
                      overlayColor: _accent.withOpacity(0.15),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 8),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      value: _hoursPerWeek.toDouble(),
                      min: 5,
                      max: 40,
                      divisions: 7,
                      onChanged: (v) =>
                          setState(() => _hoursPerWeek = v.round()),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5 hrs', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Text('40 hrs', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 40),

            // Submit
            NeonButton(
              label: _isAI ? 'Ask AI Advisor' : 'Run Logic Engine',
              icon: _isAI ? Icons.auto_awesome_rounded : Icons.account_tree_rounded,
              fullWidth: true,
              color: _accent,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _submit,
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// ── Styled text field ─────────────────────────────────────────
class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color accent;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: accent.withOpacity(0.6), size: 18),
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
    );
  }
}