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
  // ── Form state ─────────────────────────────────────────────
  String? _selectedDept;
  String? _selectedPref;
  String _difficulty = 'Medium';
  int _year = 1;
  String _prereq = 'nan'; // 'nan' means no prerequisite filter
  bool _isLoading = false;

  bool get _isAI => widget.mode == 'ai';
  Color get _accent => _isAI ? AppColors.amber : AppColors.teal;

  bool get _isFormValid => _selectedDept != null && _selectedPref != null;

  Future<void> _submit() async {
    if (!_isFormValid) {
      _showError('Please select a Department and an Interest.');
      return;
    }

    setState(() => _isLoading = true);

    final query = StudentQuery(
      dept: _selectedDept!,
      pref: _selectedPref!,
      difficulty: _difficulty,
      prereq: _prereq,
      year: _year,
    );

    try {
      final results = await ApiService.getLogicRecommendations(query);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              results: results,
              query: query,
              mode: widget.mode,
            ),
          ),
        );
      }
    } catch (e) {
      // Demo mode — backend not connected yet
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              results: CourseResult.mockResults(_selectedDept!),
              query: query,
              mode: widget.mode,
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
            Container(width: 8, height: 8,
                decoration: BoxDecoration(color: _accent, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(
              _isAI ? 'AI Advisor' : 'Logic Advisor',
              style: TextStyle(fontFamily: 'Syne', fontSize: 16,
                  fontWeight: FontWeight.w700, color: _accent),
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

            // Header
            Text('Build your\nProfile',
              style: TextStyle(fontFamily: 'Syne', fontSize: 38,
                  fontWeight: FontWeight.w800, color: AppColors.textPrimary,
                  height: 1.1, letterSpacing: -1.5),
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 6),
            const Text('Select your department, interest, difficulty and year.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 36),

            // ── Department ─────────────────────────────────────
            const SectionLabel('Department'),
            const SizedBox(height: 12),
            _DeptGrid(
              selected: _selectedDept,
              accent: _accent,
              onSelect: (d) => setState(() => _selectedDept = d),
            ).animate().fadeIn(delay: 150.ms),

            const SizedBox(height: 28),

            // ── Interest / Preference ──────────────────────────
            const SectionLabel('Your Interest'),
            const SizedBox(height: 12),
            _TagWrap(
              options: AppConstants.preferences,
              selected: _selectedPref != null ? {_selectedPref!} : {},
              accent: _accent,
              singleSelect: true,
              onToggle: (tag) => setState(() => _selectedPref = tag),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 28),

            // ── Difficulty ─────────────────────────────────────
            const SectionLabel('Difficulty'),
            const SizedBox(height: 12),
            GlowCard(
              glowColor: _accent,
              padding: const EdgeInsets.all(18),
              child: Row(
                children: AppConstants.difficulties.map((d) {
                  final selected = _difficulty == d;
                  final color = d == 'Easy'
                      ? AppColors.success
                      : d == 'Hard'
                          ? AppColors.error
                          : AppColors.amber;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _difficulty = d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? color.withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: selected ? color : AppColors.border),
                        ),
                        child: Text(d,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                              color: selected ? color : AppColors.textMuted),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 250.ms),

            const SizedBox(height: 20),

            // ── Year ───────────────────────────────────────────
            const SectionLabel('Year of Study'),
            const SizedBox(height: 12),
            GlowCard(
              glowColor: _accent,
              padding: const EdgeInsets.all(18),
              child: Row(
                children: AppConstants.years.map((y) {
                  final selected = _year == y;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _year = y),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? _accent.withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: selected ? _accent : AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Text('Y$y',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: selected ? _accent : AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 20),

            // ── Prerequisite (optional) ────────────────────────
            const SectionLabel('Known Course (optional)'),
            const SizedBox(height: 8),
            Text('Enter a course you already know — Prolog uses it to filter results.',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 10),
            _PrereqField(
              accent: _accent,
              value: _prereq == 'nan' ? '' : _prereq,
              onChanged: (v) => setState(() => _prereq = v.trim().isEmpty ? 'nan' : v.trim()),
            ).animate().fadeIn(delay: 350.ms),

            const SizedBox(height: 40),

            // ── Summary chip row ───────────────────────────────
            if (_isFormValid) ...[
              _SummaryRow(
                dept: _selectedDept!,
                pref: _selectedPref!,
                difficulty: _difficulty,
                year: _year,
                accent: _accent,
              ).animate().fadeIn(),
              const SizedBox(height: 20),
            ],

            // ── Submit ─────────────────────────────────────────
            NeonButton(
              label: 'Get Recommendations',
              icon: Icons.auto_awesome_rounded,
              fullWidth: true,
              color: _accent,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _submit,
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// ── Department grid ───────────────────────────────────────────
class _DeptGrid extends StatelessWidget {
  final String? selected;
  final Color accent;
  final void Function(String) onSelect;

  const _DeptGrid({required this.selected, required this.accent, required this.onSelect});

  static const _icons = {
    'Architecture': Icons.apartment_rounded,
    'Basic and Applied Sciences': Icons.science_rounded,
    'CE': Icons.foundation_rounded,
    'CSE': Icons.computer_rounded,
    'EE': Icons.bolt_rounded,
    'Humanities': Icons.menu_book_rounded,
    'ME': Icons.settings_rounded,
    'PE': Icons.precision_manufacturing_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: AppConstants.departments.map((dept) {
        final isSelected = selected == dept;
        return GestureDetector(
          onTap: () => onSelect(dept),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? accent.withOpacity(0.12) : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? accent : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: accent.withOpacity(0.2), blurRadius: 12)]
                  : [],
            ),
            child: Row(
              children: [
                Icon(_icons[dept] ?? Icons.school_rounded,
                    color: isSelected ? accent : AppColors.textMuted, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppConstants.deptLabels[dept] ?? dept,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? accent : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Tag wrap (interests) ──────────────────────────────────────
class _TagWrap extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final Color accent;
  final bool singleSelect;
  final void Function(String) onToggle;

  const _TagWrap({
    required this.options,
    required this.selected,
    required this.accent,
    required this.onToggle,
    this.singleSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return GestureDetector(
          onTap: () => onToggle(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? accent.withOpacity(0.15) : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? accent : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(opt,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? accent : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Prereq field ──────────────────────────────────────────────
class _PrereqField extends StatelessWidget {
  final Color accent;
  final String value;
  final void Function(String) onChanged;

  const _PrereqField({required this.accent, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'e.g. Mathematics 1 (Calculus)',
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        prefixIcon: Icon(Icons.school_outlined, color: accent.withOpacity(0.6), size: 18),
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accent, width: 1.5)),
      ),
    );
  }
}

// ── Summary row ───────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String dept, pref, difficulty;
  final int year;
  final Color accent;

  const _SummaryRow({
    required this.dept, required this.pref,
    required this.difficulty, required this.year, required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ChipTag(label: dept, color: accent),
        ChipTag(label: pref, color: accent),
        ChipTag(label: difficulty, color: accent),
        ChipTag(label: 'Year $year', color: accent),
      ],
    );
  }
}